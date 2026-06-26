/**
 * Smart Token Management System - Registration Controller
 */

document.addEventListener("DOMContentLoaded", () => {
  // DOM Form Elements
  const formCard = document.getElementById("form-card");
  const ticketCard = document.getElementById("ticket-card");
  const registrationForm = document.getElementById("registration-form");
  
  const custName = document.getElementById("cust-name");
  const custPhone = document.getElementById("cust-phone");
  const custEmail = document.getElementById("cust-email");
  const custService = document.getElementById("cust-service");
  const custDate = document.getElementById("cust-date");
  const custTimeslot = document.getElementById("cust-timeslot");
  const custRemarks = document.getElementById("cust-remarks");
  
  const btnClearForm = document.getElementById("btn-clear-form");
  const regOrgTitle = document.getElementById("reg-org-title");
  const offlineWarning = document.getElementById("offline-warning");
  const spinnerLoader = document.getElementById("spinner-loader");
  
  // Ticket Slip Output Elements
  const ticketOrgName = document.getElementById("ticket-org-name");
  const ticketNumber = document.getElementById("ticket-number");
  const ticketWaitTime = document.getElementById("ticket-wait-time");
  const ticketCustName = document.getElementById("ticket-cust-name");
  const ticketServiceType = document.getElementById("ticket-service-type");
  const ticketSource = document.getElementById("ticket-source");
  const ticketDateTime = document.getElementById("ticket-date-time");
  
  const btnPrintReceipt = document.getElementById("btn-print-receipt");
  const btnNewTicket = document.getElementById("btn-new-ticket");
  
  let lastGeneratedTicket = null;
  let settingsProfile = {
    orgName: "Smart Token Management System",
    avgServiceTime: "10"
  };

  /**
   * Initialize Page
   */
  async function init() {
    // Set default date to today
    const today = new Date().toISOString().split("T")[0];
    custDate.value = today;
    custDate.min = today; // prevent choosing past dates

    // Fetch custom org settings if API is configured
    await loadSettings();

    // Show warning if API URL is not set
    if (!SmartTokenAPI.isConfigured()) {
      offlineWarning.classList.remove("d-none");
    }

    setupEventHandlers();
  }

  /**
   * Load System Settings Configuration
   */
  async function loadSettings() {
    if (!SmartTokenAPI.isConfigured()) {
      populateServicesDropdown(["General Service", "Consultation", "Enquiry", "Premium Service"]);
      return;
    }
    const response = await SmartTokenAPI.getSettings();
    if (response.success && response.settings) {
      settingsProfile = response.settings;
      regOrgTitle.textContent = settingsProfile["Organization Name"] || "Smart Token System";

      // 1. Apply primary accent color
      if (settingsProfile["Theme Primary Color"]) {
        const primaryColor = settingsProfile["Theme Primary Color"];
        document.documentElement.style.setProperty('--primary-color', primaryColor);
      }

      // 2. Organization Logo rendering
      const logoContainer = document.getElementById("kiosk-logo-container");
      if (logoContainer) {
        if (settingsProfile["Organization Logo"]) {
          logoContainer.innerHTML = `<img src="${settingsProfile["Organization Logo"]}" alt="Logo" style="max-height: 55px; width: auto; object-fit: contain;">`;
        } else {
          logoContainer.innerHTML = `<i class="fa-solid fa-layer-group text-primary fs-2" id="kiosk-logo-icon"></i>`;
        }
      }

      // 3. Dynamic service categories population
      let categories = [];
      if (settingsProfile["Queue Service Categories"]) {
        try {
          categories = JSON.parse(settingsProfile["Queue Service Categories"]);
        } catch (_) {
          categories = ["General Service", "Consultation", "Enquiry", "Premium Service"];
        }
      } else {
        categories = ["General Service", "Consultation", "Enquiry", "Premium Service"];
      }
      populateServicesDropdown(categories);

      // 4. Form inputs validations rules
      const reqName = settingsProfile["Require Customer Name"] === "true";
      const reqPhone = settingsProfile["Require Customer Phone"] === "true";

      const nameStar = document.getElementById("name-required-star");
      const phoneStar = document.getElementById("phone-required-star");

      if (nameStar) nameStar.style.display = reqName ? "inline" : "none";
      custName.required = reqName;

      if (phoneStar) phoneStar.style.display = reqPhone ? "inline" : "none";
      custPhone.required = reqPhone;
    }
  }

  function populateServicesDropdown(categories) {
    custService.innerHTML = '<option value="" disabled selected>Select service category...</option>';
    categories.forEach(cat => {
      const opt = document.createElement("option");
      opt.value = cat;
      opt.textContent = cat;
      custService.appendChild(opt);
    });
  }

  /**
   * Configure Form and Ticket Click Events
   */
  function setupEventHandlers() {
    // 1. Submit Registration Form
    registrationForm.addEventListener("submit", async (e) => {
      e.preventDefault();
      
      // Perform HTML5 Validation check
      if (!registrationForm.checkValidity()) {
        e.stopPropagation();
        registrationForm.classList.add("was-validated");
        return;
      }

      spinnerLoader.classList.add("show");

      const name = custName.value.trim() || "Walk-In Customer";
      const phone = custPhone.value.trim() || "-";
      const email = custEmail.value.trim() || "-";
      const service = custService.value;
      const dateVal = custDate.value;
      const timeslot = custTimeslot.value;
      const remarks = custRemarks.value.trim();

      const details = {
        name: name,
        phone: phone,
        email: email,
        serviceType: service,
        source: "Online",
        remarks: `Date: ${dateVal} | Slot: ${timeslot} | Remarks: ${remarks}`
      };

      let response;
      if (SmartTokenAPI.isConfigured()) {
        // Submit details online to Google Sheets
        response = await SmartTokenAPI.generateToken(details);
      } else {
        // Run local offline mock generation
        response = simulateOfflineGeneration(details);
      }

      spinnerLoader.classList.remove("show");

      if (response && response.success) {
        lastGeneratedTicket = response;
        showSuccessTicket(response);
      } else {
        alert(response ? response.error : "Failed to generate token. Please try again.");
      }
    });

    // 2. Clear Form Button
    btnClearForm.addEventListener("click", () => {
      registrationForm.reset();
      registrationForm.classList.remove("was-validated");
      custDate.value = new Date().toISOString().split("T")[0];
    });

    // 3. Print Ticket Button
    btnPrintReceipt.addEventListener("click", () => {
      if (!lastGeneratedTicket) return;
      simulatePrintTicket(lastGeneratedTicket);
    });

    // 4. Book Another Ticket Reset
    btnNewTicket.addEventListener("click", () => {
      ticketCard.classList.add("d-none");
      formCard.classList.remove("d-none");
      registrationForm.reset();
      registrationForm.classList.remove("was-validated");
      custDate.value = new Date().toISOString().split("T")[0];
    });
  }

  /**
   * Transition view from Form to success slip
   */
  function showSuccessTicket(ticket) {
    const orgName = settingsProfile["Organization Name"] || "Smart Token Management System";
    const dateStr = ticket.dateGenerated || new Date().toISOString().split('T')[0];
    const timeStr = ticket.timeGenerated || new Date().toTimeString().split(' ')[0];

    ticketOrgName.textContent = orgName;
    ticketNumber.textContent = ticket.tokenNumber;
    ticketWaitTime.textContent = ticket.estimatedWaitingTimeMinutes;
    ticketCustName.textContent = ticket.customerName;
    ticketServiceType.textContent = ticket.serviceType;
    ticketSource.textContent = `${ticket.source} Booking`;
    ticketDateTime.textContent = `${dateStr} @ ${timeStr}`;

    // Generate QR Code dynamically pointing to token-status.html
    const qrContainer = document.getElementById("qrcode");
    qrContainer.innerHTML = "";
    const qrUrl = `${window.location.protocol}//${window.location.host}/token-status.html?token=${ticket.tokenNumber}`;
    
    if (window.QRCode) {
      new QRCode(qrContainer, {
        text: qrUrl,
        width: 128,
        height: 128,
        colorDark: "#1e293b",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.H
      });
    } else {
      qrContainer.innerHTML = "<p class='text-danger' style='font-size: 0.8rem;'>QR Code failed to load</p>";
    }

    formCard.classList.add("d-none");
    ticketCard.classList.remove("d-none");
  }

  /**
   * Offline demo token calculation helper
   */
  function simulateOfflineGeneration(details) {
    const mockToken = Math.floor(Math.random() * 900) + 100; // generate 3-digit token
    const now = new Date();
    
    return {
      success: true,
      tokenNumber: "T-" + mockToken,
      customerName: details.name,
      serviceType: details.serviceType,
      source: details.source,
      estimatedWaitingTimeMinutes: Math.floor(Math.random() * 30) + 10,
      timeGenerated: now.toTimeString().split(' ')[0],
      dateGenerated: now.toISOString().split('T')[0]
    };
  }

  /**
   * Simulated Receipt Print
   */
  function simulatePrintTicket(ticket) {
    const orgName = settingsProfile["Organization Name"] || "Smart Token Management System";
    const dateStr = ticket.dateGenerated || new Date().toISOString().split('T')[0];
    const timeStr = ticket.timeGenerated || new Date().toTimeString().split(' ')[0];

    // Grab the QR code HTML image to embed in receipt
    const qrImageHTML = document.getElementById("qrcode").innerHTML;

    const printContent = `
      <div style="font-family:'Courier New', monospace; text-align:center; padding: 20px; width: 280px; margin: auto; border: 1px dashed #000;">
        <h2 style="margin: 0 0 5px 0;">${orgName}</h2>
        <p style="font-size: 0.8rem; margin: 0 0 15px 0;">ONLINE APPOINTMENT TICKET</p>
        <hr style="border-top: 1px dashed #000; margin: 10px 0;">
        <p style="font-size: 0.9rem; margin: 5px 0;">Your Token Number is</p>
        <h1 style="font-size: 3.5rem; font-weight: bold; margin: 10px 0;">${ticket.tokenNumber}</h1>
        <p style="font-size: 0.95rem; font-weight: bold; margin: 5px 0;">${ticket.serviceType}</p>
        <p style="font-size: 0.8rem; margin: 5px 0; color: #555;">Est. Wait: ${ticket.estimatedWaitingTimeMinutes} mins</p>
        <hr style="border-top: 1px dashed #000; margin: 10px 0;">
        <p style="font-size: 0.8rem; margin: 5px 0;">Name: ${ticket.customerName}</p>
        <p style="font-size: 0.8rem; margin: 5px 0;">Date: ${dateStr} | Time: ${timeStr}</p>
        <hr style="border-top: 1px dashed #000; margin: 10px 0;">
        <div style="margin: 15px auto; text-align: center;">
          <div style="display: inline-block; padding: 5px; background: #fff; border: 1px solid #ddd;">
            ${qrImageHTML}
          </div>
          <p style="font-size: 0.7rem; margin: 5px 0 0 0; color: #555;">Scan to track live status</p>
        </div>
        <p style="font-size: 0.75rem; margin: 15px 0 0 0; font-style: italic;">Thank you for registering!</p>
      </div>
    `;

    const printFrame = document.getElementById("print-frame");
    const frameDoc = printFrame.contentDocument || printFrame.contentWindow.document;

    frameDoc.open();
    frameDoc.write(`
      <html>
        <head>
          <title>Print Ticket Receipt</title>
          <style>
            body { margin: 0; padding: 0; }
          </style>
        </head>
        <body onload="window.print();">
          ${printContent}
        </body>
      </html>
    `);
    frameDoc.close();
  }

  // Run
  init();
});
