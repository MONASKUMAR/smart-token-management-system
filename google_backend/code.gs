/**
 * Smart Token Management System - Google Apps Script Backend
 * 
 * This script runs in Google Apps Script and acts as the REST API backend.
 * It connects to a Google Sheet database containing two sheets: "Tokens" and "Settings".
 */

// Define sheet names
var TOKENS_SHEET = "Tokens";
var SETTINGS_SHEET = "Settings";

/**
 * Handle incoming GET requests
 */
function doGet(e) {
  return handleRequest(e);
}

/**
 * Handle incoming POST requests
 */
function doPost(e) {
  return handleRequest(e);
}

/**
 * Main request router
 */
function handleRequest(e) {
  var responseHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type"
  };
  
  var action = "";
  var params = {};
  
  // Extract action and parameters from GET or POST payload
  if (e.parameter && e.parameter.action) {
    action = e.parameter.action;
    params = e.parameter;
  } else if (e.postData && e.postData.contents) {
    try {
      // Attempt to parse raw JSON contents if sent via fetch POST raw body
      var jsonPayload = JSON.parse(e.postData.contents);
      action = jsonPayload.action;
      params = jsonPayload;
    } catch (err) {
      // Fall back to reading URL-encoded payload parameters
      action = e.parameter.action;
      params = e.parameter;
    }
  } else {
    action = e.parameter ? e.parameter.action : "";
    params = e.parameter || {};
  }

  var result = { success: false, error: "Unknown action: " + action };
  
  try {
    var ss = SpreadsheetApp.openById("1nYAkAw80Otz7kJodSCjqVlyQdYoqjup1eWbZ-C-WJbQ");
    if (!ss) {
      return ContentService.createTextOutput(JSON.stringify({
        success: false, 
        error: "Spreadsheet not found. Make sure the Sheet ID is correct and accessible."
      }))
      .setMimeType(ContentService.MimeType.JSON);
    }
    
    // Initialize Sheets if they don't exist
    initDatabase(ss);
    
    switch (action) {
      case "generateToken":
        result = generateToken(ss, params);
        break;
      case "getQueue":
        result = getQueue(ss);
        break;
      case "nextToken":
        result = nextToken(ss, params);
        break;
      case "completeToken":
        result = completeToken(ss, params);
        break;
      case "skipToken":
        result = skipToken(ss, params);
        break;
      case "getCurrentToken":
        result = getCurrentToken(ss);
        break;
      case "getReports":
        result = getReports(ss);
        break;
      case "getSettings":
        result = getSettings(ss);
        break;
      case "updateSettings":
        result = updateSettings(ss, params);
        break;
      case "verifyLogin":
        result = verifyLogin(ss, params);
        break;
      default:
        result = { success: false, error: "Invalid action. Supported actions: generateToken, getQueue, nextToken, completeToken, skipToken, getCurrentToken, getReports, getSettings, updateSettings, verifyLogin" };
    }
  } catch (error) {
    result = { success: false, error: error.toString() };
  }
  
  var jsonString = JSON.stringify(result);
  return ContentService.createTextOutput(jsonString)
    .setMimeType(ContentService.MimeType.JSON);
}

/**
 * Helper to get a sheet, creating it if it doesn't exist
 */
function getOrCreateSheet(ss, sheetName) {
  var sheet = ss.getSheetByName(sheetName);
  if (!sheet) {
    sheet = ss.insertSheet(sheetName);
  }
  return sheet;
}

/**
 * Initialize Sheets database structures
 */
function initDatabase(ss) {
  var tokensSheet = getOrCreateSheet(ss, TOKENS_SHEET);
  if (tokensSheet.getLastRow() === 0) {
    // Append headers
    tokensSheet.appendRow([
      "Token Number", "Customer Name", "Phone Number", "Email", 
      "Service Type", "Source", "Status", "Date", "Time", "Remarks"
    ]);
  }
  
  var settingsSheet = getOrCreateSheet(ss, SETTINGS_SHEET);
  if (settingsSheet.getLastRow() === 0) {
    // Set headers
    settingsSheet.appendRow(["Key", "Value"]);
    
    // Add default settings
    var defaults = [
      ["Starting Token Number", "100"],
      ["Last Generated Token", "100"],
      ["Current Serving Token", "0"],
      ["Average Service Time", "10"],
      ["Organization Name", "Smart Token Management System"],
      ["Enable Buzzer", "true"],
      ["Thermal Printer Settings", "Default"],
      ["Admin Password", "admin123"]
    ];
    for (var i = 0; i < defaults.length; i++) {
      settingsSheet.appendRow(defaults[i]);
    }
  }
}

/**
 * Read settings as an object map
 */
function readSettings(ss) {
  var sheet = getOrCreateSheet(ss, SETTINGS_SHEET);
  var data = sheet.getDataRange().getValues();
  var settings = {};
  for (var i = 1; i < data.length; i++) {
    var key = data[i][0];
    var val = data[i][1];
    settings[key] = val;
  }
  return settings;
}

/**
 * Update individual setting
 */
function writeSetting(ss, key, val) {
  var sheet = getOrCreateSheet(ss, SETTINGS_SHEET);
  var data = sheet.getDataRange().getValues();
  for (var i = 1; i < data.length; i++) {
    if (data[i][0] === key) {
      sheet.getRange(i + 1, 2).setValue(val);
      return;
    }
  }
  // If key not found, append
  sheet.appendRow([key, val.toString()]);
}

/**
 * generateToken()
 * Generates a new unique token number, stores details, and returns number
 */
function generateToken(ss, params) {
  var name = params.name || "Walk-In Customer";
  var phone = params.phone || "-";
  var email = params.email || "-";
  var serviceType = params.serviceType || "General Service";
  var source = params.source || "Manual"; // "Manual" or "Online"
  var remarks = params.remarks || "";
  
  var settings = readSettings(ss);
  var startingToken = parseInt(settings["Starting Token Number"] || "100", 10);
  var lastGenerated = parseInt(settings["Last Generated Token"] || "0", 10);
  var avgServiceTime = parseInt(settings["Average Service Time"] || "10", 10);
  
  // Determine new token number
  var newTokenNum = lastGenerated + 1;
  if (newTokenNum < startingToken) {
    newTokenNum = startingToken;
  }
  
  // Record time and date
  var now = new Date();
  var formattedDate = Utilities.formatDate(now, Session.getScriptTimeZone(), "yyyy-MM-dd");
  var formattedTime = Utilities.formatDate(now, Session.getScriptTimeZone(), "HH:mm:ss");
  
  // Save to Tokens sheet
  var tokensSheet = getOrCreateSheet(ss, TOKENS_SHEET);
  tokensSheet.appendRow([
    newTokenNum,
    name,
    phone,
    email,
    serviceType,
    source,
    "Waiting",
    formattedDate,
    formattedTime,
    remarks
  ]);
  
  // Update Settings
  writeSetting(ss, "Last Generated Token", newTokenNum);
  
  // Calculate waiting time: Count waiting tokens ahead of this one
  var tokensData = tokensSheet.getDataRange().getValues();
  var waitingAhead = 0;
  for (var i = 1; i < tokensData.length; i++) {
    var status = tokensData[i][6];
    var tNum = parseInt(tokensData[i][0], 10);
    // If status is Waiting or Serving, count it if it's before this token
    if ((status === "Waiting" || status === "Serving") && tNum < newTokenNum) {
      waitingAhead++;
    }
  }
  
  var estWaitingTime = waitingAhead * avgServiceTime;
  
  return {
    success: true,
    tokenNumber: newTokenNum,
    customerName: name,
    serviceType: serviceType,
    source: source,
    estimatedWaitingTimeMinutes: estWaitingTime,
    timeGenerated: formattedTime,
    dateGenerated: formattedDate
  };
}

/**
 * getQueue()
 * Returns all active waiting tokens
 */
function getQueue(ss) {
  var tokensSheet = getOrCreateSheet(ss, TOKENS_SHEET);
  var data = tokensSheet.getDataRange().getValues();
  var queue = [];
  
  for (var i = 1; i < data.length; i++) {
    var status = data[i][6];
    // Include Waiting and Serving for real-time monitoring
    if (status === "Waiting" || status === "Serving") {
      queue.push({
        tokenNumber: data[i][0],
        customerName: data[i][1],
        phoneNumber: data[i][2],
        email: data[i][3],
        serviceType: data[i][4],
        source: data[i][5],
        status: status,
        date: data[i][7],
        time: data[i][8],
        remarks: data[i][9]
      });
    }
  }
  
  return {
    success: true,
    queue: queue
  };
}

/**
 * nextToken()
 * Complete current serving token and proceed to next waiting token in queue
 */
function nextToken(ss, params) {
  var tokensSheet = getOrCreateSheet(ss, TOKENS_SHEET);
  var data = tokensSheet.getDataRange().getValues();
  
  var currentServingRow = -1;
  var nextWaitingRow = -1;
  var nextTokenNumber = -1;
  
  // Find current serving row and the first waiting row
  for (var i = 1; i < data.length; i++) {
    var status = data[i][6];
    var tokenNum = data[i][0];
    
    if (status === "Serving") {
      currentServingRow = i + 1; // 1-based index row for sheet write
    }
    
    if (status === "Waiting" && nextWaitingRow === -1) {
      nextWaitingRow = i + 1;
      nextTokenNumber = tokenNum;
    }
  }
  
  // Complete current serving token if exists
  if (currentServingRow !== -1) {
    tokensSheet.getRange(currentServingRow, 7).setValue("Completed");
  }
  
  var nextTokenDetails = null;
  
  // Serve the next waiting token
  if (nextWaitingRow !== -1) {
    tokensSheet.getRange(nextWaitingRow, 7).setValue("Serving");
    writeSetting(ss, "Current Serving Token", nextTokenNumber);
    
    nextTokenDetails = {
      tokenNumber: data[nextWaitingRow - 1][0],
      customerName: data[nextWaitingRow - 1][1],
      phoneNumber: data[nextWaitingRow - 1][2],
      serviceType: data[nextWaitingRow - 1][4],
      source: data[nextWaitingRow - 1][5],
      status: "Serving"
    };
  } else {
    // No one in queue
    writeSetting(ss, "Current Serving Token", "0");
  }
  
  return {
    success: true,
    message: nextWaitingRow !== -1 ? "Serving next token" : "No waiting tokens in queue",
    serving: nextTokenDetails
  };
}

/**
 * completeToken()
 * Marks a specific token as Completed
 */
function completeToken(ss, params) {
  var tokenNum = parseInt(params.tokenNumber, 10);
  if (!tokenNum) {
    return { success: false, error: "Missing or invalid tokenNumber" };
  }
  
  var tokensSheet = getOrCreateSheet(ss, TOKENS_SHEET);
  var data = tokensSheet.getDataRange().getValues();
  
  for (var i = 1; i < data.length; i++) {
    if (parseInt(data[i][0], 10) === tokenNum) {
      tokensSheet.getRange(i + 1, 7).setValue("Completed");
      
      // If this was the current serving token, clear it from settings
      var settings = readSettings(ss);
      if (parseInt(settings["Current Serving Token"], 10) === tokenNum) {
        writeSetting(ss, "Current Serving Token", "0");
      }
      
      return { success: true, message: "Token " + tokenNum + " completed successfully." };
    }
  }
  
  return { success: false, error: "Token " + tokenNum + " not found." };
}

/**
 * skipToken()
 * Marks a specific token as Skipped
 */
function skipToken(ss, params) {
  var tokenNum = parseInt(params.tokenNumber, 10);
  if (!tokenNum) {
    return { success: false, error: "Missing or invalid tokenNumber" };
  }
  
  var tokensSheet = getOrCreateSheet(ss, TOKENS_SHEET);
  var data = tokensSheet.getDataRange().getValues();
  
  for (var i = 1; i < data.length; i++) {
    if (parseInt(data[i][0], 10) === tokenNum) {
      tokensSheet.getRange(i + 1, 7).setValue("Skipped");
      
      // If this was the current serving token, clear it from settings
      var settings = readSettings(ss);
      if (parseInt(settings["Current Serving Token"], 10) === tokenNum) {
        writeSetting(ss, "Current Serving Token", "0");
      }
      
      return { success: true, message: "Token " + tokenNum + " marked as skipped." };
    }
  }
  
  return { success: false, error: "Token " + tokenNum + " not found." };
}

/**
 * getCurrentToken()
 * Returns the token currently being served
 */
function getCurrentToken(ss) {
  var settings = readSettings(ss);
  var servingTokenNum = parseInt(settings["Current Serving Token"] || "0", 10);
  
  if (servingTokenNum === 0) {
    return { success: true, serving: null };
  }
  
  var tokensSheet = getOrCreateSheet(ss, TOKENS_SHEET);
  var data = tokensSheet.getDataRange().getValues();
  
  for (var i = 1; i < data.length; i++) {
    var tokenNum = parseInt(data[i][0], 10);
    var status = data[i][6];
    if (tokenNum === servingTokenNum && status === "Serving") {
      return {
        success: true,
        serving: {
          tokenNumber: data[i][0],
          customerName: data[i][1],
          phoneNumber: data[i][2],
          email: data[i][3],
          serviceType: data[i][4],
          source: data[i][5],
          status: status,
          date: data[i][7],
          time: data[i][8],
          remarks: data[i][9]
        }
      };
    }
  }
  
  return { success: true, serving: null };
}

/**
 * getReports()
 * Returns stats and historical aggregation for today
 */
function getReports(ss) {
  var tokensSheet = getOrCreateSheet(ss, TOKENS_SHEET);
  var data = tokensSheet.getDataRange().getValues();
  
  var now = new Date();
  var todayStr = Utilities.formatDate(now, Session.getScriptTimeZone(), "yyyy-MM-dd");
  
  var totalTokensToday = 0;
  var manualTokensCount = 0;
  var onlineTokensCount = 0;
  var completedServicesCount = 0;
  var skippedServicesCount = 0;
  var totalWaitingTimeForCompleted = 0;
  
  var hourlyDistribution = {}; // Hour -> count
  var serviceDistribution = {}; // Service Type -> count
  var reportData = [];
  
  for (var i = 1; i < data.length; i++) {
    var dateVal = data[i][7];
    var dateStr = "";
    
    if (dateVal instanceof Date) {
      dateStr = Utilities.formatDate(dateVal, Session.getScriptTimeZone(), "yyyy-MM-dd");
    } else {
      dateStr = dateVal.toString();
    }
    
    // Process records for today only
    if (dateStr === todayStr) {
      totalTokensToday++;
      
      var source = data[i][5];
      if (source === "Manual") {
        manualTokensCount++;
      } else if (source === "Online") {
        onlineTokensCount++;
      }
      
      var status = data[i][6];
      if (status === "Completed") {
        completedServicesCount++;
      } else if (status === "Skipped") {
        skippedServicesCount++;
      }
      
      var sType = data[i][4];
      serviceDistribution[sType] = (serviceDistribution[sType] || 0) + 1;
      
      // Parse hour from Time cell
      var timeVal = data[i][8];
      var hour = "Unknown";
      if (timeVal) {
        var timeStr = timeVal.toString();
        var match = timeStr.match(/^(\d{2})/);
        if (match) {
          hour = match[1] + ":00";
        }
      }
      hourlyDistribution[hour] = (hourlyDistribution[hour] || 0) + 1;
      
      reportData.push({
        tokenNumber: data[i][0],
        customerName: data[i][1],
        phoneNumber: data[i][2],
        email: data[i][3],
        serviceType: data[i][4],
        source: data[i][5],
        status: status,
        time: data[i][8],
        remarks: data[i][9]
      });
    }
  }
  
  // Calculate average waiting time
  var settings = readSettings(ss);
  var avgServiceTime = parseInt(settings["Average Service Time"] || "10", 10);
  var calculatedAvgWaitingTime = completedServicesCount > 0 ? (completedServicesCount * avgServiceTime) / 2 : 0;
  
  return {
    success: true,
    summary: {
      date: todayStr,
      totalTokens: totalTokensToday,
      manualTokens: manualTokensCount,
      onlineTokens: onlineTokensCount,
      completedTokens: completedServicesCount,
      skippedTokens: skippedServicesCount,
      averageWaitingTimeMinutes: calculatedAvgWaitingTime.toFixed(1)
    },
    distributions: {
      byService: serviceDistribution,
      byHour: hourlyDistribution
    },
    data: reportData
  };
}

/**
 * getSettings()
 * Reads configurations
 */
function getSettings(ss) {
  var settings = readSettings(ss);
  // Redact password in public reads, though keep verification function separate
  var clientSettings = {};
  for (var key in settings) {
    if (key !== "Admin Password") {
      clientSettings[key] = settings[key];
    }
  }
  return {
    success: true,
    settings: clientSettings
  };
}

/**
 * updateSettings()
 * Updates administrative settings
 */
function updateSettings(ss, params) {
  if (params.startingToken !== undefined) writeSetting(ss, "Starting Token Number", params.startingToken);
  if (params.avgServiceTime !== undefined) writeSetting(ss, "Average Service Time", params.avgServiceTime);
  if (params.orgName !== undefined) writeSetting(ss, "Organization Name", params.orgName);
  if (params.enableBuzzer !== undefined) writeSetting(ss, "Enable Buzzer", params.enableBuzzer);
  if (params.thermalPrinterSettings !== undefined) writeSetting(ss, "Thermal Printer Settings", params.thermalPrinterSettings);
  if (params.newPassword !== undefined && params.newPassword.toString().trim() !== "") {
    writeSetting(ss, "Admin Password", params.newPassword);
  }
  
  return {
    success: true,
    message: "Settings updated successfully",
    settings: readSettings(ss)
  };
}

/**
 * verifyLogin()
 * Verifies staff password
 */
function verifyLogin(ss, params) {
  var username = params.username || "";
  var password = params.password || "";
  
  var settings = readSettings(ss);
  var adminPass = settings["Admin Password"] || "admin123";
  
  if (username.toLowerCase() === "admin" && password === adminPass) {
    return {
      success: true,
      message: "Authentication successful",
      role: "admin",
      token: "session_" + Utilities.getUuid()
    };
  } else {
    return {
      success: false,
      error: "Invalid username or password"
    };
  }
}
