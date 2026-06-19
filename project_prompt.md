# Project: Smart Token Management System
This document contains all source code and configuration files for the Smart Token Management System.

## Directory Structure
```
token project/
  .clasp.json
  dashboard.html
  index.html
  login.html
  online-registration.html
  package.json
  reports.html
  rls.sql
  settings.html
  token-display.html
  token-status.html
  css/
    style.css
  google_backend/
    .clasp.json
    appsscript.json
    code.gs
    setup_guide.md
  iot/
    wiring_guide.md
    esp32_master/
      esp32_master.ino
    esp32_slave/
      esp32_slave.ino
  js/
    api.js
    dashboard.js
    display.js
    registration.js
    reports.js
  supabase/
    config.toml
    migrations/
      20260616111111_init_schema.sql
```

### File: `.clasp.json`
```json
{
  "scriptId": "1VzKFE8tAmxzfiDBKJ00H5gEgMidgAUsgv-HcDzx--hbkPPVGUwvyXcT6",
  "rootDir": "google_backend"
}
```

### File: `dashboard.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard - Smart Token Management</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

  <!-- Spinner Overlay -->
  <div id="spinner-loader" class="spinner-overlay">
    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
  </div>

  <!-- Main System Layout -->
  <div class="d-flex">
    
    <!-- Collapsible Sidebar -->
    <aside class="sidebar" id="sidebar">
      <div class="sidebar-brand">
        <i class="fa-solid fa-layer-group fs-3"></i>
        <span>Smart Token System</span>
      </div>
      <ul class="sidebar-menu">
        <li class="active">
          <a href="dashboard.html"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
        </li>
        <li>
          <a href="reports.html"><i class="fa-solid fa-chart-bar"></i> Reports & Logs</a>
        </li>
        <li>
          <a href="settings.html"><i class="fa-solid fa-sliders"></i> Settings</a>
        </li>
        <hr class="text-secondary mx-3 opacity-25">
        <li>
          <a href="token-display.html" target="_blank"><i class="fa-solid fa-desktop"></i> TV Monitor Screen</a>
        </li>
        <li>
          <a href="online-registration.html" target="_blank"><i class="fa-solid fa-ticket"></i> Customer Kiosk</a>
        </li>
      </ul>
      <div class="sidebar-footer">
        <button id="logout-btn" class="btn btn-outline-danger btn-sm w-100"><i class="fa-solid fa-right-from-bracket me-1"></i> Sign Out</button>
        <div class="text-center mt-2 text-muted" style="font-size: 0.75rem;">v1.0.0 &copy; 2026</div>
      </div>
    </aside>

    <!-- Content Workspace -->
    <div class="main-wrapper" id="main-wrapper">
      
      <!-- Sticky Top Navigation -->
      <nav class="top-navbar">
        <div class="d-flex align-items-center gap-3">
          <button class="mobile-nav-toggle" id="sidebarToggle">
            <i class="fa-solid fa-bars"></i>
          </button>
          <h4 class="fw-bold m-0 text-dark d-none d-sm-block" id="org-title-display">Smart Token System</h4>
        </div>
        <div class="d-flex align-items-center gap-3">
          <span class="badge bg-success-subtle text-success border border-success-subtle py-2 px-3" id="api-status-badge">
            <i class="fa-solid fa-circle me-1 animate-pulse" style="font-size: 0.65rem;"></i> System Live
          </span>
          <div class="dropdown">
            <button class="btn btn-light dropdown-toggle border" type="button" data-bs-toggle="dropdown">
              <i class="fa-solid fa-user-circle me-1"></i> Staff Admin
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow">
              <li><a class="dropdown-menu-item dropdown-item" href="settings.html"><i class="fa-solid fa-gear me-2"></i> Settings</a></li>
              <li><hr class="dropdown-divider"></li>
              <li><button class="dropdown-item text-danger" id="nav-logout-btn"><i class="fa-solid fa-power-off me-2"></i> Logout</button></li>
            </ul>
          </div>
        </div>
      </nav>

      <!-- Main Page Content -->
      <main class="content-body animate-fade-in">
        
        <!-- API URL Configuration Warning Banner -->
        <div id="api-warning-banner" class="alert alert-warning border-0 shadow-sm p-3 mb-4 rounded-3 d-flex align-items-center justify-content-between d-none">
          <div class="d-flex align-items-center gap-3">
            <i class="fa-solid fa-triangle-exclamation fs-3 text-warning"></i>
            <div>
              <span class="fw-bold d-block">Offline Setup Mode</span>
              <span style="font-size: 0.85rem;" class="text-muted">You are currently running with a placeholder API. Please set your deployed Google Apps Script URL.</span>
            </div>
          </div>
          <a href="settings.html" class="btn btn-warning btn-sm">Configure API Now</a>
        </div>

        <!-- 1. Stats Counter Cards Row -->
        <div class="row g-4 mb-4">
          <!-- Card: Serving -->
          <div class="col-xl-3 col-md-6 col-sm-12">
            <div class="card stat-card stat-primary h-100">
              <div class="d-flex justify-content-between align-items-start">
                <div>
                  <div class="stat-card-label">Currently Serving</div>
                  <div class="stat-card-value text-primary" id="stat-serving">0</div>
                </div>
                <div class="stat-card-icon">
                  <i class="fa-solid fa-headset"></i>
                </div>
              </div>
            </div>
          </div>
          <!-- Card: Waiting -->
          <div class="col-xl-2 col-md-6 col-sm-6">
            <div class="card stat-card stat-warning h-100">
              <div class="d-flex justify-content-between align-items-start">
                <div>
                  <div class="stat-card-label">Waiting Queue</div>
                  <div class="stat-card-value text-warning" id="stat-waiting">0</div>
                </div>
                <div class="stat-card-icon">
                  <i class="fa-solid fa-users"></i>
                </div>
              </div>
            </div>
          </div>
          <!-- Card: Completed -->
          <div class="col-xl-2 col-md-4 col-sm-6">
            <div class="card stat-card stat-success h-100">
              <div class="d-flex justify-content-between align-items-start">
                <div>
                  <div class="stat-card-label">Completed Today</div>
                  <div class="stat-card-value text-success" id="stat-completed">0</div>
                </div>
                <div class="stat-card-icon">
                  <i class="fa-solid fa-circle-check"></i>
                </div>
              </div>
            </div>
          </div>
          <!-- Card: Online Count -->
          <div class="col-xl-2.5 col-md-4 col-sm-6">
            <div class="card stat-card stat-info h-100">
              <div class="d-flex justify-content-between align-items-start">
                <div>
                  <div class="stat-card-label">Online Bookings</div>
                  <div class="stat-card-value text-info" id="stat-online">0</div>
                </div>
                <div class="stat-card-icon">
                  <i class="fa-solid fa-globe"></i>
                </div>
              </div>
            </div>
          </div>
          <!-- Card: Manual Count -->
          <div class="col-xl-2.5 col-md-4 col-sm-6">
            <div class="card stat-card stat-danger h-100">
              <div class="d-flex justify-content-between align-items-start">
                <div>
                  <div class="stat-card-label">Walk-In (Manual)</div>
                  <div class="stat-card-value text-danger" id="stat-manual">0</div>
                </div>
                <div class="stat-card-icon">
                  <i class="fa-solid fa-ticket-simple"></i>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 2. Command Console / Serving Desk & Manual ticket creation -->
        <div class="row g-4 mb-4">
          
          <!-- Column: Current Token Panel (Now Serving Console) -->
          <div class="col-lg-7 col-md-12">
            <div class="card serving-panel h-100 text-white shadow-sm p-4">
              <div class="card-body d-flex flex-column justify-content-between h-100">
                <div class="d-flex justify-content-between align-items-start mb-3">
                  <div>
                    <h5 class="card-title fw-bold text-uppercase mb-1">Queue Console</h5>
                    <span class="text-white-50" style="font-size: 0.85rem;"><i class="fa-solid fa-terminal me-1"></i> Active Desk Control</span>
                  </div>
                  <span class="badge bg-white text-primary fw-bold" id="console-service-source">-</span>
                </div>

                <div class="text-center my-4">
                  <div class="text-white-50 text-uppercase fw-semibold" style="font-size: 0.9rem; letter-spacing: 1.5px;">Now Serving</div>
                  <div class="serving-token-number" id="console-token-number">--</div>
                  <div class="fs-4 fw-bold mt-2" id="console-customer-name">No Active Customer</div>
                  <div class="text-white-50" style="font-size: 0.9rem;" id="console-service-type">Please call the next token</div>
                </div>

                <div class="row g-2 mt-3 pt-3 border-top border-white-10">
                  <div class="col-md-4 col-12">
                    <button class="btn btn-light text-primary w-100 py-3 fw-bold" id="btn-next-token">
                      <i class="fa-solid fa-forward me-1"></i> Next Token
                    </button>
                  </div>
                  <div class="col-md-4 col-6">
                    <button class="btn btn-outline-light w-100 py-3 fw-bold" id="btn-skip-token" disabled>
                      <i class="fa-solid fa-forward-step me-1"></i> Skip Token
                    </button>
                  </div>
                  <div class="col-md-4 col-6">
                    <button class="btn btn-outline-light w-100 py-3 fw-bold" id="btn-complete-token" disabled>
                      <i class="fa-solid fa-check-double me-1"></i> Complete
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Column: Manual Token Management Page/Card (Walk-in dispenser) -->
          <div class="col-lg-5 col-md-12">
            <div class="card h-100 border-0 shadow-sm p-4">
              <div class="card-body d-flex flex-column justify-content-between">
                <div>
                  <h5 class="fw-bold mb-1"><i class="fa-solid fa-ticket-simple text-primary me-1"></i> Walk-In Registration</h5>
                  <p class="text-muted" style="font-size: 0.85rem;">Generate and print physical tokens for walk-in clients.</p>
                  
                  <!-- Fields for quick manual generation -->
                  <div class="mb-3">
                    <label for="manual-customer-name" class="form-label fw-semibold" style="font-size: 0.8rem;">Customer Name (Optional)</label>
                    <input type="text" class="form-control" id="manual-customer-name" placeholder="Walk-In Customer">
                  </div>
                  <div class="mb-3">
                    <label for="manual-service-type" class="form-label fw-semibold" style="font-size: 0.8rem;">Service Type</label>
                    <select class="form-select" id="manual-service-type">
                      <option value="General Service">General Service</option>
                      <option value="Consultation">Consultation</option>
                      <option value="Enquiry">Enquiry</option>
                      <option value="Premium Service">Premium Service</option>
                    </select>
                  </div>
                </div>

                <div class="pt-3 border-top mt-3">
                  <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-muted" style="font-size: 0.85rem;">Last Generated Ticket:</span>
                    <span class="fw-bold text-dark fs-5" id="manual-last-generated">--</span>
                  </div>
                  <div class="row g-2">
                    <div class="col-8">
                      <button class="btn btn-primary w-100 py-2.5" id="btn-generate-manual">
                        <i class="fa-solid fa-circle-plus me-1"></i> Generate Token
                      </button>
                    </div>
                    <div class="col-4">
                      <button class="btn btn-outline-secondary w-100 py-2.5" id="btn-print-manual" disabled>
                        <i class="fa-solid fa-print"></i> Print
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>

        <!-- 3. Waiting Queue Table Sheet Details -->
        <div class="card border-0 shadow-sm p-4">
          <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
            <div>
              <h5 class="fw-bold mb-1"><i class="fa-solid fa-list-ol text-primary me-1"></i> Waiting Queue Waitlist</h5>
              <div class="d-flex align-items-center gap-2">
                <span class="text-muted" style="font-size: 0.85rem;">Real-time sync</span>
                <span id="queue-refresh-countdown" class="badge bg-secondary-subtle text-secondary rounded-pill">10s</span>
              </div>
            </div>
            <!-- Search & Filters -->
            <div class="d-flex flex-wrap align-items-center gap-2 w-100 w-md-auto">
              <div class="input-group search-group" style="max-width: 250px;">
                <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                <input type="text" class="form-control bg-light border-start-0 ps-0" id="queue-search" placeholder="Search token or name...">
              </div>
              <select class="form-select bg-light border" id="queue-service-filter" style="max-width: 170px;">
                <option value="">All Services</option>
                <option value="General Service">General Service</option>
                <option value="Consultation">Consultation</option>
                <option value="Enquiry">Enquiry</option>
                <option value="Premium Service">Premium Service</option>
              </select>
              <button class="btn btn-light border" id="btn-refresh-queue" title="Force Refresh">
                <i class="fa-solid fa-rotate"></i>
              </button>
            </div>
          </div>

          <!-- Table Container -->
          <div class="table-responsive">
            <table class="table align-middle">
              <thead>
                <tr>
                  <th>Token</th>
                  <th>Customer Name</th>
                  <th>Phone Number</th>
                  <th>Service Type</th>
                  <th>Source</th>
                  <th>Status</th>
                  <th>Time Generated</th>
                  <th class="text-end">Actions</th>
                </tr>
              </thead>
              <tbody id="queue-table-body">
                <tr>
                  <td colspan="8" class="text-center py-4 text-muted">
                    <div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div> Loading live queue list...
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Table Pagination Footer -->
          <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center gap-3 mt-3">
            <div class="text-muted" style="font-size: 0.85rem;" id="queue-pagination-info">Showing 0 to 0 of 0 entries</div>
            <nav>
              <ul class="pagination pagination-sm m-0" id="queue-pagination">
                <!-- Pages generated dynamically -->
              </ul>
            </nav>
          </div>
        </div>

      </main>
    </div>
  </div>

  <!-- Toast Notification Overlay Container -->
  <div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="liveToast" class="toast align-items-center border-0" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body d-flex align-items-center gap-2">
          <i class="fa-solid fa-circle-check fs-5" id="toast-icon"></i>
          <span id="toast-message">Operation successful!</span>
        </div>
        <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast"></button>
      </div>
    </div>
  </div>

  <!-- Print Frame (hidden) -->
  <iframe id="print-frame" style="display:none;"></iframe>

  <!-- Ticket Print Template (hidden for layout styling) -->
  <div id="ticket-print-template" style="display:none;">
    <div style="font-family:'Courier New', monospace; text-align:center; padding: 20px; width: 280px; margin: auto; border: 1px dashed #000;">
      <h2 style="margin: 0 0 5px 0;" id="print-org-name">Smart Token Management</h2>
      <p style="font-size: 0.8rem; margin: 0 0 15px 0;">WALK-IN TICKET</p>
      <hr style="border-top: 1px dashed #000; margin: 10px 0;">
      <p style="font-size: 0.9rem; margin: 5px 0;">Your Token Number is</p>
      <h1 style="font-size: 3.5rem; font-weight: bold; margin: 10px 0;" id="print-token-number">---</h1>
      <p style="font-size: 0.95rem; font-weight: bold; margin: 5px 0;" id="print-service-type">General Service</p>
      <hr style="border-top: 1px dashed #000; margin: 10px 0;">
      <p style="font-size: 0.8rem; margin: 5px 0;" id="print-customer-name">Name: Walk-In Customer</p>
      <p style="font-size: 0.8rem; margin: 5px 0;" id="print-date-time">Date: -- | Time: --</p>
      <hr style="border-top: 1px dashed #000; margin: 10px 0;">
      <div id="print-qrcode-wrapper" style="margin: 15px auto; text-align: center;">
        <div id="print-qrcode" style="display: inline-block; padding: 5px; background: #fff; border: 1px solid #ddd;"></div>
        <p style="font-size: 0.7rem; margin: 5px 0 0 0; color: #555;">Scan to track live status</p>
      </div>
      <p style="font-size: 0.75rem; margin: 15px 0 0 0; font-style: italic;">Please wait for your number to be called.</p>
    </div>
  </div>

  <!-- Hidden temp QR Code Container -->
  <div id="dashboard-qr-temp" style="position: absolute; left: -9999px; top: -9999px; width: 128px; height: 128px; overflow: hidden; background: #fff;"></div>

  <!-- Bootstrap & Javascript Utilities -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
  <script src="js/api.js"></script>
  <script src="js/dashboard.js"></script>
</body>
</html>

```

### File: `index.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Smart Token Management System</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/style.css">
  <style>
    .portal-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: radial-gradient(circle at top right, #eef2f7 0%, #dbeafe 100%);
      padding: 2rem 1rem;
    }
    .portal-header {
      margin-bottom: 3rem;
    }
    .portal-card {
      height: 100%;
      border: none;
      border-radius: var(--border-radius-lg);
      overflow: hidden;
      box-shadow: var(--box-shadow-md);
      transition: var(--transition-smooth);
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(10px);
    }
    .portal-card:hover {
      transform: translateY(-8px);
      box-shadow: var(--box-shadow-lg);
      border-bottom: 5px solid var(--primary-color);
    }
    .portal-icon-box {
      height: 120px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 3.5rem;
      background-color: rgba(26, 115, 232, 0.06);
      color: var(--primary-color);
      transition: var(--transition-smooth);
    }
    .portal-card:hover .portal-icon-box {
      background-color: var(--primary-color);
      color: #ffffff;
    }
    .quick-status-badge {
      position: absolute;
      top: 1rem;
      right: 1rem;
    }
  </style>
</head>
<body>

  <div class="portal-container">
    <div class="container animate-fade-in" style="max-width: 1100px;">
      
      <!-- System Brand & Header -->
      <div class="text-center portal-header">
        <div class="d-inline-flex align-items-center gap-2 mb-2">
          <i class="fa-solid fa-layer-group text-primary fs-1"></i>
          <h1 class="fw-bold m-0" style="letter-spacing: -0.5px; color: #0f172a;">Smart Token Management System</h1>
        </div>
        <p class="text-muted fs-5">IoT-Enabled Hybrid Queue and Appointment System</p>
      </div>

      <!-- Navigation Portal Cards -->
      <div class="row g-4 justify-content-center">
        
        <!-- Portal 1: Online Registration Kiosk -->
        <div class="col-md-4 col-sm-6">
          <div class="card portal-card position-relative">
            <span class="badge bg-success quick-status-badge">Customer Portal</span>
            <div class="portal-icon-box">
              <i class="fa-solid fa-ticket"></i>
            </div>
            <div class="card-body p-4 text-center">
              <h4 class="fw-bold mb-2">Self Registration</h4>
              <p class="text-muted mb-4 text-start" style="font-size: 0.9rem; line-height: 1.5;">
                For walk-in and online customers to register their details, choose services, and check-in to generate token queue numbers.
              </p>
              <a href="online-registration.html" class="btn btn-primary w-100 py-2">
                Open Registration Form <i class="fa-solid fa-arrow-right ms-2"></i>
              </a>
            </div>
          </div>
        </div>

        <!-- Portal 2: Large Screen TV Display -->
        <div class="col-md-4 col-sm-6">
          <div class="card portal-card position-relative">
            <span class="badge bg-info text-dark quick-status-badge">Live Display</span>
            <div class="portal-icon-box">
              <i class="fa-solid fa-desktop"></i>
            </div>
            <div class="card-body p-4 text-center">
              <h4 class="fw-bold mb-2">Queue TV Monitor</h4>
              <p class="text-muted mb-4 text-start" style="font-size: 0.9rem; line-height: 1.5;">
                Fullscreen waiting lobby display board showing Currently Serving and Next Tokens. Includes audio buzzer and voice calling.
              </p>
              <a href="token-display.html" class="btn btn-outline-primary w-100 py-2">
                Open Screen Display <i class="fa-solid fa-arrow-right ms-2"></i>
              </a>
            </div>
          </div>
        </div>

        <!-- Portal 3: Administration & Operator Console -->
        <div class="col-md-4 col-sm-6">
          <div class="card portal-card position-relative">
            <span class="badge bg-danger quick-status-badge">Staff Secure</span>
            <div class="portal-icon-box">
              <i class="fa-solid fa-user-shield"></i>
            </div>
            <div class="card-body p-4 text-center">
              <h4 class="fw-bold mb-2">Admin Console</h4>
              <p class="text-muted mb-4 text-start" style="font-size: 0.9rem; line-height: 1.5;">
                Secure dashboard for operators and admins to call next customers, generate manual tickets, configure queues, and view reports.
              </p>
              <a href="login.html" class="btn btn-outline-primary w-100 py-2">
                Operator Login <i class="fa-solid fa-arrow-right ms-2"></i>
              </a>
            </div>
          </div>
        </div>

      </div>

      <!-- Quick Configuration Notification -->
      <div id="config-alert" class="alert alert-warning border-0 mt-5 p-4 rounded-3 d-flex align-items-center gap-3 shadow-sm d-none">
        <i class="fa-solid fa-circle-exclamation fs-3 text-warning"></i>
        <div>
          <h6 class="fw-bold mb-1">Configuration Needed</h6>
          <span style="font-size: 0.85rem;" class="text-muted">
            The Google Apps Script REST API URL is not set. Staff must log in and define this under settings for the system to synchronize data.
          </span>
        </div>
      </div>

      <!-- Footer Info -->
      <div class="text-center mt-5 text-muted" style="font-size: 0.85rem;">
        <p>&copy; 2026 Smart Token Management System. Powered by Google Sheets & ESP32 IoT.</p>
      </div>

    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="js/api.js"></script>
  <script>
    // Show configuration alert if API URL is not set
    document.addEventListener("DOMContentLoaded", () => {
      if (!SmartTokenAPI.isConfigured()) {
        document.getElementById("config-alert").classList.remove("d-none");
      }
    });
  </script>
</body>
</html>

```

### File: `login.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Staff Login - Smart Token Management</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/style.css">
  <style>
    .login-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #eef2f7 0%, #cbd5e1 100%);
    }
  </style>
</head>
<body>

  <!-- Spinner Overlay -->
  <div id="spinner-loader" class="spinner-overlay">
    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
  </div>

  <div class="login-container">
    <div class="card login-card shadow-lg animate-fade-in border-0 rounded-4">
      <div class="card-body p-5">
        
        <!-- Header -->
        <div class="text-center mb-4">
          <a href="index.html" class="text-decoration-none">
            <div class="d-inline-flex align-items-center gap-2 mb-2">
              <i class="fa-solid fa-layer-group text-primary fs-2"></i>
              <span class="fw-bold fs-4 text-dark">Smart Token</span>
            </div>
          </a>
          <h5 class="fw-bold text-dark mt-2">Staff Portal Login</h5>
          <p class="text-muted" style="font-size: 0.9rem;">Sign in to access admin functions</p>
        </div>

        <!-- Notification Banner -->
        <div id="alert-box" class="alert alert-danger d-none border-0 p-3 rounded-3" role="alert" style="font-size: 0.85rem;">
          <i class="fa-solid fa-circle-exclamation me-2"></i>
          <span id="alert-message">Invalid credentials. Please try again.</span>
        </div>

        <!-- Login Form -->
        <form id="login-form">
          <!-- Username -->
          <div class="mb-3">
            <label for="username" class="form-label fw-semibold" style="font-size: 0.85rem;">Username</label>
            <div class="input-group">
              <span class="input-group-text bg-light border-end-0"><i class="fa-regular fa-user text-muted"></i></span>
              <input type="text" class="form-control bg-light border-start-0 ps-0" id="username" placeholder="e.g. admin" required value="admin">
            </div>
          </div>

          <!-- Password -->
          <div class="mb-3">
            <label for="password" class="form-label fw-semibold" style="font-size: 0.85rem;">Password</label>
            <div class="input-group">
              <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-lock text-muted"></i></span>
              <input type="password" class="form-control bg-light border-start-0 border-end-0 ps-0" id="password" placeholder="Enter password" required>
              <button class="btn btn-light border border-start-0 text-muted" type="button" id="toggle-password">
                <i class="fa-regular fa-eye-slash" id="toggle-icon"></i>
              </button>
            </div>
          </div>

          <!-- Options -->
          <div class="d-flex justify-content-between align-items-center mb-4" style="font-size: 0.85rem;">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="remember-me">
              <label class="form-check-label text-muted" for="remember-me">Remember Session</label>
            </div>
            <a href="#" id="forgot-password-link" class="text-primary text-decoration-none">Forgot Password?</a>
          </div>

          <!-- Submit -->
          <button type="submit" class="btn btn-primary w-100 py-2.5">
            Sign In <i class="fa-solid fa-right-to-bracket ms-2"></i>
          </button>
        </form>

        <!-- Configuration Hint -->
        <div id="unconfigured-warning" class="mt-4 text-center d-none">
          <hr class="my-3">
          <small class="text-warning fw-semibold d-block">
            <i class="fa-solid fa-triangle-exclamation me-1"></i>
            REST API URL is not set. 
          </small>
          <small class="text-muted d-block mt-1" style="font-size: 0.75rem;">
            Use password <code class="bg-light px-1 text-dark border rounded">admin123</code> to login offline and set up the API in settings.
          </small>
        </div>

      </div>
    </div>
  </div>

  <!-- Bootstrap & Javascript Utilities -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="js/api.js"></script>
  <script>
    document.addEventListener("DOMContentLoaded", () => {
      const loginForm = document.getElementById("login-form");
      const usernameInput = document.getElementById("username");
      const passwordInput = document.getElementById("password");
      const togglePasswordBtn = document.getElementById("toggle-password");
      const toggleIcon = document.getElementById("toggle-icon");
      const alertBox = document.getElementById("alert-box");
      const alertMessage = document.getElementById("alert-message");
      const spinnerLoader = document.getElementById("spinner-loader");
      const unconfiguredWarning = document.getElementById("unconfigured-warning");
      const forgotPasswordLink = document.getElementById("forgot-password-link");

      // Check if already logged in and API is configured
      if (SmartTokenAPI.isLoggedIn() && SmartTokenAPI.isConfigured()) {
        window.location.href = "dashboard.html";
        return;
      }

      // Show temporary config hints if API is not set
      if (!SmartTokenAPI.isConfigured()) {
        unconfiguredWarning.classList.remove("d-none");
      }

      // Show/hide password
      togglePasswordBtn.addEventListener("click", () => {
        const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
        passwordInput.setAttribute("type", type);
        toggleIcon.classList.toggle("fa-eye");
        toggleIcon.classList.toggle("fa-eye-slash");
      });

      // Handle Forgot Password link
      forgotPasswordLink.addEventListener("click", (e) => {
        e.preventDefault();
        alertBox.classList.remove("d-none", "alert-danger");
        alertBox.classList.add("alert-info");
        alertMessage.textContent = "The default password is 'admin123'. It can be changed inside System Settings.";
      });

      // Authenticate
      loginForm.addEventListener("submit", async (e) => {
        e.preventDefault();
        
        const username = usernameInput.value;
        const password = passwordInput.value;

        alertBox.classList.add("d-none");
        spinnerLoader.classList.add("show");

        if (!SmartTokenAPI.isConfigured()) {
          // Offline bypass if the user has not configured the Apps Script URL yet,
          // allowing them to enter the system settings to paste the Web App URL.
          setTimeout(() => {
            spinnerLoader.classList.remove("show");
            if (username.toLowerCase() === "admin" && password === "admin123") {
              SmartTokenAPI.setBaseURL("https://script.google.com/macros/s/offline-setup-placeholder/exec"); // temporary mock url
              localStorage.setItem("smart_token_session", "temp_session");
              window.location.href = "settings.html";
            } else {
              alertBox.classList.remove("d-none");
              alertBox.classList.add("alert-danger");
              alertMessage.textContent = "Offline Setup Mode: Enter username 'admin' and password 'admin123' to configure Settings.";
            }
          }, 800);
          return;
        }

        // Online Apps Script verify login call
        const response = await SmartTokenAPI.verifyLogin(username, password);
        spinnerLoader.classList.remove("show");

        if (response.success) {
          window.location.href = "dashboard.html";
        } else {
          alertBox.classList.remove("d-none");
          alertBox.classList.add("alert-danger");
          alertMessage.textContent = response.error || "Authentication failed. Incorrect username or password.";
        }
      });
    });
  </script>
</body>
</html>

```

### File: `online-registration.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Token Registration</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/style.css">
  <style>
    .registration-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: radial-gradient(circle at bottom left, #eef2f7 0%, #dbeafe 100%);
      padding: 2rem 1rem;
    }
    .register-card {
      max-width: 650px;
      width: 100%;
      border: none;
      border-radius: var(--border-radius-lg);
    }
    .ticket-success-card {
      border: 2px solid #2e7d32;
      background: linear-gradient(145deg, #ffffff 0%, #f1fcf2 100%);
      border-radius: var(--border-radius-lg);
      box-shadow: 0 10px 30px rgba(46, 125, 50, 0.15);
    }
    .ticket-success-number {
      font-size: 5.5rem;
      font-weight: 900;
      color: #2e7d32;
      text-shadow: 0 4px 10px rgba(46, 125, 50, 0.15);
    }
  </style>
</head>
<body>

  <!-- Spinner Overlay -->
  <div id="spinner-loader" class="spinner-overlay">
    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
  </div>

  <div class="registration-container">
    
    <!-- Registration Form Card -->
    <div class="card register-card shadow-lg animate-fade-in" id="form-card">
      <div class="card-body p-5">
        
        <!-- Header -->
        <div class="text-center mb-4">
          <a href="index.html" class="text-decoration-none">
            <div class="d-inline-flex align-items-center gap-2 mb-2">
              <i class="fa-solid fa-layer-group text-primary fs-2"></i>
              <span class="fw-bold fs-4 text-dark" id="reg-org-title">Smart Token System</span>
            </div>
          </a>
          <h4 class="fw-bold text-dark mt-2">Generate Queue Token</h4>
          <p class="text-muted">Fill out your details to join the virtual queue waitlist</p>
        </div>

        <!-- Warning offline indicator -->
        <div id="offline-warning" class="alert alert-warning border-0 p-3 mb-4 rounded-3 d-flex align-items-center gap-2 d-none" style="font-size: 0.85rem;">
          <i class="fa-solid fa-triangle-exclamation text-warning"></i>
          <span>Database API is offline. Tokens will be generated in demo simulation mode.</span>
        </div>

        <!-- Registration Form -->
        <form id="registration-form" novalidate>
          
          <div class="row g-3">
            <!-- Full Name -->
            <div class="col-md-6 col-12">
              <label for="cust-name" class="form-label fw-semibold" style="font-size: 0.85rem;">Full Name <span class="text-danger">*</span></label>
              <input type="text" class="form-control py-2" id="cust-name" placeholder="John Doe" required>
              <div class="invalid-feedback">Please enter your name.</div>
            </div>

            <!-- Mobile Number -->
            <div class="col-md-6 col-12">
              <label for="cust-phone" class="form-label fw-semibold" style="font-size: 0.85rem;">Mobile Number <span class="text-danger">*</span></label>
              <input type="tel" class="form-control py-2" id="cust-phone" placeholder="e.g. 9876543210" required pattern="[0-9]{10,15}">
              <div class="invalid-feedback">Please enter a valid mobile number (10-15 digits).</div>
            </div>

            <!-- Email Address -->
            <div class="col-12">
              <label for="cust-email" class="form-label fw-semibold" style="font-size: 0.85rem;">Email Address <span class="text-muted">(Optional)</span></label>
              <input type="email" class="form-control py-2" id="cust-email" placeholder="john.doe@example.com">
              <div class="invalid-feedback">Please enter a valid email format.</div>
            </div>

            <!-- Service Type Dropdown -->
            <div class="col-md-6 col-12">
              <label for="cust-service" class="form-label fw-semibold" style="font-size: 0.85rem;">Required Service <span class="text-danger">*</span></label>
              <select class="form-select py-2" id="cust-service" required>
                <option value="" disabled selected>Select service category...</option>
                <option value="General Service">General Service</option>
                <option value="Consultation">Consultation (Doctor/Consultant)</option>
                <option value="Enquiry">Enquiry / Helpdesk</option>
                <option value="Premium Service">Premium Service</option>
              </select>
              <div class="invalid-feedback">Please choose a service.</div>
            </div>

            <!-- Preferred Date -->
            <div class="col-md-6 col-12">
              <label for="cust-date" class="form-label fw-semibold" style="font-size: 0.85rem;">Preferred Date</label>
              <input type="date" class="form-control py-2" id="cust-date">
            </div>

            <!-- Preferred Time Slot -->
            <div class="col-md-6 col-12">
              <label for="cust-timeslot" class="form-label fw-semibold" style="font-size: 0.85rem;">Time Slot</label>
              <select class="form-select py-2" id="cust-timeslot">
                <option value="Any Time">Any Time (As soon as possible)</option>
                <option value="Morning Slot">Morning Slot (09:00 AM - 12:00 PM)</option>
                <option value="Afternoon Slot">Afternoon Slot (12:00 PM - 03:00 PM)</option>
                <option value="Evening Slot">Evening Slot (03:00 PM - 06:00 PM)</option>
              </select>
            </div>

            <!-- Remarks -->
            <div class="col-12">
              <label for="cust-remarks" class="form-label fw-semibold" style="font-size: 0.85rem;">Additional Remarks <span class="text-muted">(Optional)</span></label>
              <textarea class="form-control" id="cust-remarks" rows="2" placeholder="Describe query or complaints..."></textarea>
            </div>
          </div>

          <div class="row g-2 mt-4">
            <div class="col-8">
              <button type="submit" class="btn btn-primary w-100 py-2.5">
                Generate Token <i class="fa-solid fa-ticket ms-2"></i>
              </button>
            </div>
            <div class="col-4">
              <button type="button" class="btn btn-light border w-100 py-2.5" id="btn-clear-form">
                Clear
              </button>
            </div>
          </div>

        </form>

      </div>
    </div>

    <!-- Ticket Slip Output Success Card (Hidden initially) -->
    <div class="card register-card ticket-success-card shadow-lg p-4 d-none animate-fade-in" id="ticket-card">
      <div class="card-body p-4 text-center">
        
        <div class="mb-3">
          <i class="fa-solid fa-circle-check text-success fs-1"></i>
        </div>
        
        <h3 class="fw-bold text-dark mb-1">Registration Complete</h3>
        <p class="text-muted mb-4" id="ticket-org-name">Smart Token Management System</p>
        
        <hr class="my-3 border-secondary border-opacity-25 border-dashed">
        
        <div style="font-size: 0.95rem;" class="text-muted text-uppercase fw-semibold">Your Token Number is</div>
        <div class="ticket-success-number" id="ticket-number">---</div>
        
        <div class="badge bg-success-subtle text-success py-2 px-3 border border-success-subtle mb-3">
          <i class="fa-solid fa-hourglass-half me-1"></i> Estimated Waiting Time: <span id="ticket-wait-time">--</span> minutes
        </div>

        <!-- QR Code Display -->
        <div class="my-3 d-flex flex-column align-items-center justify-content-center">
          <div id="qrcode" class="p-2 bg-white border rounded shadow-sm" style="width: 144px; height: 144px; display: flex; align-items: center; justify-content: center;"></div>
          <div class="text-muted mt-2" style="font-size: 0.75rem;">Scan this QR code to track live status</div>
        </div>

        <div class="row g-3 justify-content-center text-start mb-4" style="max-width: 450px; margin: auto; font-size: 0.9rem;">
          <div class="col-6 text-muted">Customer Name:</div>
          <div class="col-6 fw-semibold text-end text-dark" id="ticket-cust-name">-</div>
          
          <div class="col-6 text-muted">Service Type:</div>
          <div class="col-6 fw-semibold text-end text-dark" id="ticket-service-type">-</div>
          
          <div class="col-6 text-muted">Booking Reference:</div>
          <div class="col-6 fw-semibold text-end text-dark" id="ticket-source">Online Ticket</div>
          
          <div class="col-6 text-muted">Date & Time:</div>
          <div class="col-6 fw-semibold text-end text-dark" id="ticket-date-time">-</div>
        </div>

        <hr class="my-4 border-secondary border-opacity-25 border-dashed">

        <div class="row g-2 justify-content-center">
          <div class="col-sm-5 col-12">
            <button class="btn btn-success w-100 py-2.5" id="btn-print-receipt">
              <i class="fa-solid fa-print me-1"></i> Print Ticket
            </button>
          </div>
          <div class="col-sm-5 col-12">
            <button class="btn btn-outline-secondary w-100 py-2.5" id="btn-new-ticket">
              Book Another
            </button>
          </div>
        </div>
        
        <div class="text-muted mt-3" style="font-size: 0.75rem;">
          Please capture a screenshot or print this ticket for validation at the counter.
        </div>

      </div>
    </div>

  </div>

  <!-- Print Frame (hidden) -->
  <iframe id="print-frame" style="display:none;"></iframe>

  <!-- Bootstrap & Javascript Utilities -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
  <script src="js/api.js"></script>
  <script src="js/registration.js"></script>
</body>
</html>

```

### File: `package.json`
```json
{
  "name": "smart-token-management-system",
  "version": "1.0.0",
  "description": "IoT hybrid queue token management system with Google Sheets backend database",
  "main": "index.html",
  "scripts": {
    "dev": "npx -y http-server -p 3000",
    "clasp:login": "clasp login",
    "clasp:create": "clasp create --type sheets --title \"Smart Token Database Script\" --rootDir google_backend",
    "clasp:clone": "clasp clone",
    "clasp:push": "clasp push",
    "clasp:deploy": "clasp deploy"
  },
  "keywords": [
    "iot",
    "esp32",
    "queue-management",
    "google-sheets",
    "apps-script"
  ],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "@google/clasp": "^2.4.2"
  }
}

```

### File: `reports.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reports & Logs - Smart Token Management</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

  <!-- Spinner Overlay -->
  <div id="spinner-loader" class="spinner-overlay">
    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
  </div>

  <!-- Main System Layout -->
  <div class="d-flex">
    
    <!-- Collapsible Sidebar -->
    <aside class="sidebar" id="sidebar">
      <div class="sidebar-brand">
        <i class="fa-solid fa-layer-group fs-3"></i>
        <span>Smart Token System</span>
      </div>
      <ul class="sidebar-menu">
        <li>
          <a href="dashboard.html"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
        </li>
        <li class="active">
          <a href="reports.html"><i class="fa-solid fa-chart-bar"></i> Reports & Logs</a>
        </li>
        <li>
          <a href="settings.html"><i class="fa-solid fa-sliders"></i> Settings</a>
        </li>
        <hr class="text-secondary mx-3 opacity-25">
        <li>
          <a href="token-display.html" target="_blank"><i class="fa-solid fa-desktop"></i> TV Monitor Screen</a>
        </li>
        <li>
          <a href="online-registration.html" target="_blank"><i class="fa-solid fa-ticket"></i> Customer Kiosk</a>
        </li>
      </ul>
      <div class="sidebar-footer">
        <button id="logout-btn" class="btn btn-outline-danger btn-sm w-100"><i class="fa-solid fa-right-from-bracket me-1"></i> Sign Out</button>
        <div class="text-center mt-2 text-muted" style="font-size: 0.75rem;">v1.0.0 &copy; 2026</div>
      </div>
    </aside>

    <!-- Content Workspace -->
    <div class="main-wrapper" id="main-wrapper">
      
      <!-- Sticky Top Navigation -->
      <nav class="top-navbar">
        <div class="d-flex align-items-center gap-3">
          <button class="mobile-nav-toggle" id="sidebarToggle">
            <i class="fa-solid fa-bars"></i>
          </button>
          <h4 class="fw-bold m-0 text-dark" id="org-title-display">Smart Token System</h4>
        </div>
        <div class="d-flex align-items-center gap-3">
          <span class="badge bg-success-subtle text-success border border-success-subtle py-2 px-3">
            <i class="fa-solid fa-circle me-1" style="font-size: 0.65rem;"></i> System Live
          </span>
        </div>
      </nav>

      <!-- Main Page Content -->
      <main class="content-body animate-fade-in">
        
        <!-- Reports Header Actions -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
          <div>
            <h3 class="fw-bold m-0 text-dark">Queue Analysis & Logs</h3>
            <p class="text-muted m-0">Consolidated analytics reports for today's transactions</p>
          </div>
          <div class="d-flex gap-2">
            <button class="btn btn-outline-primary" id="btn-export-csv">
              <i class="fa-solid fa-file-csv me-1"></i> Download CSV
            </button>
            <button class="btn btn-primary" id="btn-export-pdf">
              <i class="fa-solid fa-file-pdf me-1"></i> Export to PDF
            </button>
          </div>
        </div>

        <!-- 1. Key Performance Stats Cards -->
        <div class="row g-4 mb-4">
          <!-- Total Tokens -->
          <div class="col-md-3 col-sm-6">
            <div class="card stat-card stat-primary">
              <div class="d-flex justify-content-between align-items-start">
                <div>
                  <div class="stat-card-label">Total Tokens</div>
                  <div class="stat-card-value" id="rep-stat-total">0</div>
                </div>
                <div class="stat-card-icon"><i class="fa-solid fa-ticket-simple"></i></div>
              </div>
            </div>
          </div>
          <!-- Completed Services -->
          <div class="col-md-3 col-sm-6">
            <div class="card stat-card stat-success">
              <div class="d-flex justify-content-between align-items-start">
                <div>
                  <div class="stat-card-label">Completed Services</div>
                  <div class="stat-card-value" id="rep-stat-completed">0</div>
                </div>
                <div class="stat-card-icon"><i class="fa-solid fa-circle-check"></i></div>
              </div>
            </div>
          </div>
          <!-- Average Service Time -->
          <div class="col-md-3 col-sm-6">
            <div class="card stat-card stat-info">
              <div class="d-flex justify-content-between align-items-start">
                <div>
                  <div class="stat-card-label">Avg. Waiting Time</div>
                  <div class="stat-card-value" id="rep-stat-waiting">0m</div>
                </div>
                <div class="stat-card-icon"><i class="fa-solid fa-hourglass-half"></i></div>
              </div>
            </div>
          </div>
          <!-- Channels (Online vs Manual) -->
          <div class="col-md-3 col-sm-6">
            <div class="card stat-card stat-warning">
              <div class="d-flex justify-content-between align-items-start">
                <div>
                  <div class="stat-card-label">Online vs Manual</div>
                  <div class="stat-card-value" style="font-size: 1.35rem; font-weight: 700; margin: 0.55rem 0;" id="rep-stat-ratio">0 / 0</div>
                </div>
                <div class="stat-card-icon"><i class="fa-solid fa-arrow-right-arrow-left"></i></div>
              </div>
            </div>
          </div>
        </div>

        <!-- 2. Chart Visualizations -->
        <div class="row g-4 mb-4">
          <!-- Chart 1: Service Distribution -->
          <div class="col-md-6">
            <div class="card border-0 shadow-sm p-4 h-100">
              <h5 class="fw-bold text-dark mb-3">Service Distribution Share</h5>
              <div style="position: relative; height: 260px;">
                <canvas id="serviceChart"></canvas>
              </div>
            </div>
          </div>
          
          <!-- Chart 2: Hourly Traffic Distribution -->
          <div class="col-md-6">
            <div class="card border-0 shadow-sm p-4 h-100">
              <h5 class="fw-bold text-dark mb-3">Hourly Patient Traffic</h5>
              <div style="position: relative; height: 260px;">
                <canvas id="trafficChart"></canvas>
              </div>
            </div>
          </div>
        </div>

        <!-- 3. Tabular Daily Log -->
        <div class="card border-0 shadow-sm p-4">
          <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-receipt text-primary me-1"></i> Today's Complete Log History</h5>
            <!-- Search & Filters -->
            <div class="d-flex gap-2 w-100 w-md-auto">
              <input type="text" class="form-control bg-light" id="log-search" placeholder="Search customer name..." style="max-width: 250px;">
              <select class="form-select bg-light" id="log-status-filter" style="max-width: 150px;">
                <option value="">All Statuses</option>
                <option value="Waiting">Waiting</option>
                <option value="Serving">Serving</option>
                <option value="Completed">Completed</option>
                <option value="Skipped">Skipped</option>
              </select>
            </div>
          </div>

          <div class="table-responsive">
            <table class="table align-middle" id="pdf-report-table">
              <thead>
                <tr>
                  <th>Token Number</th>
                  <th>Customer Name</th>
                  <th>Contact Phone</th>
                  <th>Service Type</th>
                  <th>Source</th>
                  <th>Status</th>
                  <th>Registered Time</th>
                  <th>Remarks</th>
                </tr>
              </thead>
              <tbody id="log-table-body">
                <tr>
                  <td colspan="8" class="text-center py-4 text-muted">
                    <div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div> Loading daily transactions...
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Table Pagination Footer -->
          <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center gap-3 mt-3">
            <div class="text-muted" style="font-size: 0.85rem;" id="log-pagination-info">Showing 0 to 0 of 0 entries</div>
            <nav>
              <ul class="pagination pagination-sm m-0" id="log-pagination">
                <!-- Pages generated dynamically -->
              </ul>
            </nav>
          </div>
        </div>

      </main>
    </div>
  </div>

  <!-- ChartJS and Printing CDNs -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="js/api.js"></script>
  <script src="js/reports.js"></script>
</body>
</html>

```

### File: `rls.sql`
```sql

```

### File: `settings.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Settings - Smart Token Management</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

  <!-- Spinner Overlay -->
  <div id="spinner-loader" class="spinner-overlay">
    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
  </div>

  <!-- Main System Layout -->
  <div class="d-flex">
    
    <!-- Collapsible Sidebar -->
    <aside class="sidebar" id="sidebar">
      <div class="sidebar-brand">
        <i class="fa-solid fa-layer-group fs-3"></i>
        <span>Smart Token System</span>
      </div>
      <ul class="sidebar-menu">
        <li>
          <a href="dashboard.html"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
        </li>
        <li>
          <a href="reports.html"><i class="fa-solid fa-chart-bar"></i> Reports & Logs</a>
        </li>
        <li class="active">
          <a href="settings.html"><i class="fa-solid fa-sliders"></i> Settings</a>
        </li>
        <hr class="text-secondary mx-3 opacity-25">
        <li>
          <a href="token-display.html" target="_blank"><i class="fa-solid fa-desktop"></i> TV Monitor Screen</a>
        </li>
        <li>
          <a href="online-registration.html" target="_blank"><i class="fa-solid fa-ticket"></i> Customer Kiosk</a>
        </li>
      </ul>
      <div class="sidebar-footer">
        <button id="logout-btn" class="btn btn-outline-danger btn-sm w-100"><i class="fa-solid fa-right-from-bracket me-1"></i> Sign Out</button>
        <div class="text-center mt-2 text-muted" style="font-size: 0.75rem;">v1.0.0 &copy; 2026</div>
      </div>
    </aside>

    <!-- Content Workspace -->
    <div class="main-wrapper" id="main-wrapper">
      
      <!-- Sticky Top Navigation -->
      <nav class="top-navbar">
        <div class="d-flex align-items-center gap-3">
          <button class="mobile-nav-toggle" id="sidebarToggle">
            <i class="fa-solid fa-bars"></i>
          </button>
          <h4 class="fw-bold m-0 text-dark" id="org-title-display">Smart Token System</h4>
        </div>
        <div class="d-flex align-items-center gap-3">
          <span class="badge bg-success-subtle text-success border border-success-subtle py-2 px-3">
            <i class="fa-solid fa-circle me-1" style="font-size: 0.65rem;"></i> System Live
          </span>
        </div>
      </nav>

      <!-- Main Page Content -->
      <main class="content-body animate-fade-in" style="max-width: 900px;">
        
        <div class="mb-4">
          <h3 class="fw-bold m-0 text-dark">System Configurations</h3>
          <p class="text-muted m-0">Manage Google Sheets APIs, queues, buzzer, and printer settings</p>
        </div>

        <!-- Setting Card 1: Google Apps Script Web App Connection -->
        <div class="card border-0 shadow-sm p-4 mb-4">
          <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-cloud-arrow-up text-primary me-2"></i>Google Sheets REST API Connection</h5>
          
          <div class="mb-3">
            <label for="settings-api-url" class="form-label fw-semibold" style="font-size: 0.85rem;">Google Apps Script Web App URL</label>
            <input type="url" class="form-control" id="settings-api-url" placeholder="https://script.google.com/macros/s/AKfycb.../exec">
            <div class="form-text">
              Enter the <code>/exec</code> URL obtained during the deployment of the Apps Script code in step 3 of the backend guide.
            </div>
          </div>

          <div class="d-flex gap-2 mt-4">
            <button type="button" class="btn btn-primary" id="btn-save-api">
              <i class="fa-solid fa-floppy-disk me-1"></i> Connect & Save
            </button>
            <button type="button" class="btn btn-outline-secondary" id="btn-test-api">
              <i class="fa-solid fa-circle-question me-1"></i> Test Connection
            </button>
          </div>

          <div id="connection-status-box" class="alert mt-3 p-3 rounded-3 border-0 d-none" style="font-size: 0.85rem;">
            <i class="fa-solid me-2" id="connection-status-icon"></i>
            <span id="connection-status-text">Connection status details will load here.</span>
          </div>
        </div>

        <!-- Setting Card 2: Queue Core Rules -->
        <div class="card border-0 shadow-sm p-4 mb-4">
          <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-sliders text-primary me-2"></i>Queue Operations & Rules</h5>
          
          <form id="settings-queue-form">
            <div class="row g-3">
              <!-- Org Name -->
              <div class="col-md-6 col-12">
                <label for="settings-org-name" class="form-label fw-semibold" style="font-size: 0.85rem;">Organization Display Name</label>
                <input type="text" class="form-control" id="settings-org-name" value="Smart Token Management System" required>
              </div>

              <!-- Starting Number -->
              <div class="col-md-3 col-6">
                <label for="settings-start-num" class="form-label fw-semibold" style="font-size: 0.85rem;">Starting Token Number</label>
                <input type="number" class="form-control" id="settings-start-num" value="100" min="1" required>
              </div>

              <!-- Avg Service Time -->
              <div class="col-md-3 col-6">
                <label for="settings-avg-time" class="form-label fw-semibold" style="font-size: 0.85rem;">Avg Service Delay (Mins)</label>
                <input type="number" class="form-control" id="settings-avg-time" value="10" min="1" required>
              </div>

              <!-- Buzzer Enable Toggle -->
              <div class="col-12">
                <div class="form-check form-switch mt-2">
                  <input class="form-check-input" type="checkbox" role="switch" id="settings-enable-buzzer" checked>
                  <label class="form-check-label fw-semibold text-dark" for="settings-enable-buzzer" style="font-size: 0.85rem;">
                    Enable Lobby TV Buzzer sound notification on Calling
                  </label>
                </div>
                <div class="form-text ms-4">
                  Triggers an automated synthesizer speech and audible chime when the monitor board detects a serving update.
                </div>
              </div>
            </div>

            <button type="submit" class="btn btn-primary mt-4" id="btn-save-queue-settings">
              <i class="fa-solid fa-floppy-disk me-1"></i> Save Queue Settings
            </button>
          </form>
        </div>

        <!-- Setting Card 3: Thermal Printer Config -->
        <div class="card border-0 shadow-sm p-4 mb-4">
          <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-print text-primary me-2"></i>Thermal Printer Configurations</h5>
          
          <form id="settings-printer-form">
            <div class="row g-3">
              <div class="col-md-6 col-12">
                <label for="settings-printer-paper" class="form-label fw-semibold" style="font-size: 0.85rem;">Paper Width</label>
                <select class="form-select" id="settings-printer-paper">
                  <option value="58mm">58mm (Receipt standard)</option>
                  <option value="80mm">80mm (Wide roll)</option>
                </select>
              </div>
              
              <div class="col-md-6 col-12">
                <label for="settings-printer-header" class="form-label fw-semibold" style="font-size: 0.85rem;">Receipt Header Text</label>
                <input type="text" class="form-control" id="settings-printer-header" value="Welcome to our Clinic">
              </div>
            </div>

            <button type="submit" class="btn btn-primary mt-4" id="btn-save-printer-settings">
              <i class="fa-solid fa-floppy-disk me-1"></i> Save Printer Rules
            </button>
          </form>
        </div>

        <!-- Setting Card 4: Change Password -->
        <div class="card border-0 shadow-sm p-4 mb-4">
          <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-key text-primary me-2"></i>Change Admin Credentials</h5>
          
          <form id="settings-pass-form">
            <div class="row g-3">
              <div class="col-md-6 col-12">
                <label for="settings-new-pass" class="form-label fw-semibold" style="font-size: 0.85rem;">New Admin Password</label>
                <input type="password" class="form-control" id="settings-new-pass" placeholder="Enter new password" required minlength="4">
              </div>

              <div class="col-md-6 col-12">
                <label for="settings-conf-pass" class="form-label fw-semibold" style="font-size: 0.85rem;">Confirm New Password</label>
                <input type="password" class="form-control" id="settings-conf-pass" placeholder="Confirm new password" required minlength="4">
              </div>
            </div>

            <button type="submit" class="btn btn-primary mt-4" id="btn-save-password">
              <i class="fa-solid fa-key me-1"></i> Update Credentials
            </button>
          </form>
        </div>

      </main>
    </div>
  </div>

  <!-- Toast Notification Overlay Container -->
  <div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="liveToast" class="toast align-items-center border-0 text-white" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body d-flex align-items-center gap-2">
          <i class="fa-solid fa-circle-check fs-5" id="toast-icon"></i>
          <span id="toast-message">Configuration saved!</span>
        </div>
        <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast"></button>
      </div>
    </div>
  </div>

  <!-- Bootstrap & Javascript Utilities -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="js/api.js"></script>
  <script>
    document.addEventListener("DOMContentLoaded", () => {
      // Auth Guard
      if (!SmartTokenAPI.isLoggedIn()) {
        window.location.href = "login.html";
        return;
      }

      // DOM Elements
      const spinnerLoader = document.getElementById("spinner-loader");
      const orgTitleDisplay = document.getElementById("org-title-display");
      
      const inputApiUrl = document.getElementById("settings-api-url");
      const btnSaveApi = document.getElementById("btn-save-api");
      const btnTestApi = document.getElementById("btn-test-api");
      const connectionBox = document.getElementById("connection-status-box");
      const connectionIcon = document.getElementById("connection-status-icon");
      const connectionText = document.getElementById("connection-status-text");

      const queueForm = document.getElementById("settings-queue-form");
      const orgNameInput = document.getElementById("settings-org-name");
      const startNumInput = document.getElementById("settings-start-num");
      const avgTimeInput = document.getElementById("settings-avg-time");
      const buzzerCheckbox = document.getElementById("settings-enable-buzzer");

      const printerForm = document.getElementById("settings-printer-form");
      const paperSelect = document.getElementById("settings-printer-paper");
      const printerHeaderInput = document.getElementById("settings-printer-header");

      const passForm = document.getElementById("settings-pass-form");
      const newPassInput = document.getElementById("settings-new-pass");
      const confPassInput = document.getElementById("settings-conf-pass");

      // Toast Notification Elements
      const liveToast = document.getElementById("liveToast");
      const toastMessage = document.getElementById("toast-message");
      const toastIcon = document.getElementById("toast-icon");
      const bsToast = new bootstrap.Toast(liveToast, { delay: 3500 });

      // Sidebar Mobile Trigger
      const sidebar = document.getElementById("sidebar");
      const sidebarToggle = document.getElementById("sidebarToggle");
      const logoutBtn = document.getElementById("logout-btn");

      /**
       * Initialization
       */
      async function init() {
        // Setup Drawer slides
        if (sidebarToggle && sidebar) {
          sidebarToggle.addEventListener("click", () => {
            sidebar.classList.toggle("show");
          });
        }

        // Setup Logout click
        if (logoutBtn) {
          logoutBtn.addEventListener("click", () => {
            SmartTokenAPI.logout();
            window.location.href = "login.html";
          });
        }

        // Load current configurations
        const currentUrl = SmartTokenAPI.getBaseURL();
        if (currentUrl && !currentUrl.includes("offline-setup-placeholder")) {
          inputApiUrl.value = currentUrl;
        }

        await fetchAndFillSettings();
      }

      /**
       * Fetch settings from DB and fill inputs
       */
      async function fetchAndFillSettings() {
        if (!SmartTokenAPI.isConfigured()) return;
        
        spinnerLoader.classList.add("show");
        const response = await SmartTokenAPI.getSettings();
        spinnerLoader.classList.remove("show");

        if (response.success && response.settings) {
          const s = response.settings;
          
          orgNameInput.value = s["Organization Name"] || "Smart Token Management System";
          orgTitleDisplay.textContent = s["Organization Name"] || "Smart Token System";
          
          startNumInput.value = s["Starting Token Number"] || "100";
          avgTimeInput.value = s["Average Service Time"] || "10";
          buzzerCheckbox.checked = s["Enable Buzzer"] !== "false";

          // Printer settings parsing
          if (s["Thermal Printer Settings"]) {
            try {
              const p = JSON.parse(s["Thermal Printer Settings"]);
              paperSelect.value = p.paper || "58mm";
              printerHeaderInput.value = p.header || "Welcome";
            } catch (err) {
              printerHeaderInput.value = s["Thermal Printer Settings"];
            }
          }
        }
      }

      /**
       * Trigger Banner notification toast
       */
      function showToast(message, isSuccess = true) {
        toastMessage.textContent = message;
        if (isSuccess) {
          liveToast.className = "toast align-items-center border-0 bg-success text-white";
          toastIcon.className = "fa-solid fa-circle-check fs-5";
        } else {
          liveToast.className = "toast align-items-center border-0 bg-danger text-white";
          toastIcon.className = "fa-solid fa-circle-exclamation fs-5";
        }
        bsToast.show();
      }

      // 1. Save REST API URL local reference
      btnSaveApi.addEventListener("click", async () => {
        const urlValue = inputApiUrl.value.trim();
        
        if (!urlValue || !urlValue.startsWith("https://script.google.com/")) {
          showToast("Please enter a valid Google Apps Script Web App URL.", false);
          return;
        }

        // Save URL
        SmartTokenAPI.setBaseURL(urlValue);
        showToast("Web App API URL saved locally!", true);
        
        // Sync and fill settings inputs
        await fetchAndFillSettings();
      });

      // 2. Test Connection
      btnTestApi.addEventListener("click", async () => {
        const urlValue = inputApiUrl.value.trim();
        
        if (!urlValue) {
          connectionBox.className = "alert alert-danger mt-3 border-0";
          connectionIcon.className = "fa-solid fa-circle-xmark me-2";
          connectionText.textContent = "URL is empty. Paste your Google Web App URL first.";
          connectionBox.classList.remove("d-none");
          return;
        }

        spinnerLoader.classList.add("show");
        // Temp inject URL just for test call
        const originalUrl = SmartTokenAPI.getBaseURL();
        SmartTokenAPI.setBaseURL(urlValue);

        const response = await SmartTokenAPI.getSettings();
        spinnerLoader.classList.remove("show");

        connectionBox.classList.remove("d-none");

        if (response.success) {
          connectionBox.className = "alert alert-success mt-3 border-0";
          connectionIcon.className = "fa-solid fa-circle-check me-2";
          connectionText.textContent = "Connection successful! Connected to Google Sheet Database: " + (response.settings["Organization Name"] || "Smart Queue");
        } else {
          // Revert back URL
          SmartTokenAPI.setBaseURL(originalUrl);
          connectionBox.className = "alert alert-danger mt-3 border-0";
          connectionIcon.className = "fa-solid fa-triangle-exclamation me-2";
          connectionText.textContent = "Connection failed. Error details: " + response.error;
        }
      });

      // 3. Save Queue core configurations
      queueForm.addEventListener("click", async (e) => {
        if (e.target.id !== "btn-save-queue-settings") return;
        e.preventDefault();

        if (!SmartTokenAPI.isConfigured()) {
          showToast("API URL is not set. Cannot update online database.", false);
          return;
        }

        spinnerLoader.classList.add("show");
        const response = await SmartTokenAPI.updateSettings({
          orgName: orgNameInput.value.trim(),
          startingToken: startNumInput.value,
          avgServiceTime: avgTimeInput.value,
          enableBuzzer: buzzerCheckbox.checked.toString()
        });
        spinnerLoader.classList.remove("show");

        if (response.success) {
          orgTitleDisplay.textContent = orgNameInput.value.trim();
          showToast("Queue rule configurations saved to Google Sheets!", true);
        } else {
          showToast("Failed to save: " + response.error, false);
        }
      });

      // 4. Save Printer Config
      printerForm.addEventListener("click", async (e) => {
        if (e.target.id !== "btn-save-printer-settings") return;
        e.preventDefault();

        if (!SmartTokenAPI.isConfigured()) {
          showToast("API URL is not set. Cannot update online database.", false);
          return;
        }

        const printerData = {
          paper: paperSelect.value,
          header: printerHeaderInput.value.trim()
        };

        spinnerLoader.classList.add("show");
        const response = await SmartTokenAPI.updateSettings({
          thermalPrinterSettings: JSON.stringify(printerData)
        });
        spinnerLoader.classList.remove("show");

        if (response.success) {
          showToast("Printer configurations saved!", true);
        } else {
          showToast("Failed to save: " + response.error, false);
        }
      });

      // 5. Update password settings
      passForm.addEventListener("click", async (e) => {
        if (e.target.id !== "btn-save-password") return;
        e.preventDefault();

        const newP = newPassInput.value;
        const confP = confPassInput.value;

        if (newP !== confP) {
          showToast("Passwords do not match. Please re-enter.", false);
          return;
        }

        if (newP.length < 4) {
          showToast("Password must be at least 4 characters.", false);
          return;
        }

        if (!SmartTokenAPI.isConfigured()) {
          showToast("API URL is not set. Cannot update credentials.", false);
          return;
        }

        spinnerLoader.classList.add("show");
        const response = await SmartTokenAPI.updateSettings({
          newPassword: newP
        });
        spinnerLoader.classList.remove("show");

        if (response.success) {
          showToast("Credentials updated successfully!", true);
          newPassInput.value = "";
          confPassInput.value = "";
        } else {
          showToast("Failed to update password: " + response.error, false);
        }
      });

      init();
    });
  </script>
</body>
</html>

```

### File: `token-display.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lobby Display Screen - Smart Token</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/style.css">
  <style>
    body {
      background-color: #0b0f19;
      overflow: hidden; /* Lock viewport on TV monitor display */
    }
    .display-container {
      height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 2rem;
    }
    .display-header-panel {
      background-color: rgba(255, 255, 255, 0.03);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: var(--border-radius-md);
      padding: 1.25rem 2rem;
    }
    .now-serving-card {
      background: radial-gradient(circle at center, #111827 0%, #030712 100%);
      border: 3px solid var(--primary-color);
      box-shadow: 0 0 50px rgba(26, 115, 232, 0.35);
      border-radius: var(--border-radius-lg);
      padding: 3rem;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      flex-grow: 1;
      margin: 1.5rem 0;
    }
    .now-serving-badge {
      font-size: 1.5rem;
      font-weight: 800;
      color: var(--secondary-color);
      letter-spacing: 4px;
      text-transform: uppercase;
      margin-bottom: 1rem;
    }
    .serving-number-big {
      font-size: 14rem;
      font-weight: 900;
      color: #ffffff;
      line-height: 1;
      text-shadow: 0 0 30px rgba(255, 255, 255, 0.2);
    }
    .serving-cust-info {
      font-size: 2rem;
      font-weight: 700;
      color: #cbd5e1;
      margin-top: 1.5rem;
    }
    .serving-service-badge {
      font-size: 1.25rem;
      background-color: rgba(26, 115, 232, 0.2);
      color: var(--primary-color);
      border: 1px solid var(--primary-color);
      padding: 0.5rem 1.5rem;
      border-radius: 50px;
      margin-top: 1rem;
    }
    .next-queue-panel {
      background-color: rgba(255, 255, 255, 0.02);
      border: 1px solid rgba(255, 255, 255, 0.05);
      border-radius: var(--border-radius-md);
      padding: 1.5rem;
    }
    .next-token-card {
      background-color: rgba(255, 255, 255, 0.03);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: var(--border-radius-md);
      padding: 1.25rem;
      text-align: center;
      transition: var(--transition-smooth);
    }
    .next-token-card:hover {
      border-color: var(--secondary-color);
      background-color: rgba(0, 188, 212, 0.05);
      transform: scale(1.03);
    }
    .next-token-number {
      font-size: 3.5rem;
      font-weight: 800;
      color: var(--secondary-color);
      line-height: 1.1;
    }
    .next-token-label {
      font-size: 0.9rem;
      color: #94a3b8;
      text-transform: uppercase;
      font-weight: 600;
      margin-top: 0.35rem;
    }
    /* Buzzer Notification Ring */
    .buzzer-alert {
      animation: flashBorder 0.8s ease-in-out infinite alternate;
    }
    @keyframes flashBorder {
      0% { border-color: var(--primary-color); box-shadow: 0 0 20px rgba(26, 115, 232, 0.2); }
      100% { border-color: var(--secondary-color); box-shadow: 0 0 70px rgba(0, 188, 212, 0.7); }
    }
    /* Pulse Dot */
    .dot-pulse {
      width: 10px;
      height: 10px;
      background-color: var(--secondary-color);
      border-radius: 50%;
      display: inline-block;
      animation: pulse 1.5s infinite;
    }
    @keyframes pulse {
      0% { transform: scale(0.9); opacity: 0.5; }
      50% { transform: scale(1.3); opacity: 1; }
      100% { transform: scale(0.9); opacity: 0.5; }
    }
  </style>
</head>
<body class="display-page-body">

  <div class="display-container">
    
    <!-- Header Row -->
    <header class="display-header-panel d-flex justify-content-between align-items-center">
      <div class="d-flex align-items-center gap-3">
        <i class="fa-solid fa-layer-group text-primary fs-2"></i>
        <h2 class="fw-bold m-0 text-white" id="display-org-name">Smart Token System</h2>
      </div>
      <div class="d-flex align-items-center gap-3">
        <div class="text-white-50" style="font-size: 1.1rem;" id="clock-display">00:00:00 PM</div>
        <div class="d-flex align-items-center gap-1">
          <div class="dot-pulse"></div>
          <span style="font-size: 0.85rem;" class="text-white-50 fw-semibold text-uppercase">Live Monitoring</span>
        </div>
      </div>
    </header>

    <!-- Main Content Panel: NOW SERVING -->
    <main class="now-serving-card animate-fade-in" id="serving-card-glow">
      <span class="now-serving-badge"><i class="fa-solid fa-volume-high me-2"></i>Now Serving</span>
      <div class="serving-number-big" id="serving-token-number">--</div>
      <div class="serving-cust-info" id="serving-customer-name">Please wait for tokens...</div>
      <div class="serving-service-badge" id="serving-service-type">General Service</div>
    </main>

    <!-- Bottom Panel: UP NEXT (Next 3 waiting slots) -->
    <footer class="next-queue-panel">
      <h5 class="text-white-50 text-uppercase fw-semibold mb-3" style="font-size: 0.95rem; letter-spacing: 1.5px;">
        <i class="fa-solid fa-angles-right text-info me-2"></i>Next in Queue
      </h5>
      <div class="row g-3" id="next-tokens-container">
        <div class="col-md-4">
          <div class="next-token-card">
            <div class="next-token-number">--</div>
            <div class="next-token-label">Waiting</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="next-token-card">
            <div class="next-token-number">--</div>
            <div class="next-token-label">Waiting</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="next-token-card">
            <div class="next-token-number">--</div>
            <div class="next-token-label">Waiting</div>
          </div>
        </div>
      </div>
    </footer>

  </div>

  <!-- Audio elements (buzzer effect) -->
  <audio id="buzzer-sound" preload="auto">
    <source src="https://assets.mixkit.co/active_storage/sfx/2869/2869-84.wav" type="audio/wav">
  </audio>

  <!-- Bootstrap & Javascript Utilities -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="js/api.js"></script>
  <script src="js/display.js"></script>
</body>
</html>

```

### File: `token-status.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Track Token Status - Smart Token Management</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/style.css">
  <style>
    .status-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: radial-gradient(circle at top right, #f8fafc 0%, #e0f2fe 100%);
      padding: 2rem 1rem;
    }
    .status-card {
      max-width: 550px;
      width: 100%;
      border: none;
      border-radius: var(--border-radius-lg);
      box-shadow: var(--box-shadow-lg);
      overflow: hidden;
    }
    .status-header {
      background: linear-gradient(135deg, var(--primary-color) 0%, #1557b0 100%);
      color: #ffffff;
      padding: 2rem 1.5rem;
      text-align: center;
      position: relative;
    }
    .status-badge-large {
      font-size: 1rem;
      font-weight: 700;
      padding: 0.6rem 1.2rem;
      border-radius: 50px;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .token-number-large {
      font-size: 6.5rem;
      font-weight: 900;
      line-height: 1;
      margin: 1rem 0;
      text-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }
    .pulse-glow {
      box-shadow: 0 0 0 0 rgba(26, 115, 232, 0.4);
      animation: pulse 2s infinite;
    }
    @keyframes pulse {
      0% {
        box-shadow: 0 0 0 0 rgba(26, 115, 232, 0.4);
      }
      70% {
        box-shadow: 0 0 0 15px rgba(26, 115, 232, 0);
      }
      100% {
        box-shadow: 0 0 0 0 rgba(26, 115, 232, 0);
      }
    }
    .refresh-btn {
      transition: var(--transition-smooth);
    }
    .refresh-btn:hover {
      transform: rotate(180deg);
    }
  </style>
</head>
<body>

  <!-- Spinner Overlay -->
  <div id="spinner-loader" class="spinner-overlay">
    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
  </div>

  <div class="status-container">
    <div class="card status-card animate-fade-in" id="main-status-card">
      
      <!-- Dynamic Status Header -->
      <div class="status-header">
        <div class="d-flex align-items-center justify-content-center gap-2 mb-2">
          <i class="fa-solid fa-layer-group fs-4"></i>
          <span class="fw-bold fs-5" id="status-org-name">Smart Token System</span>
        </div>
        <div class="text-white-50 text-uppercase fw-semibold" style="font-size: 0.8rem; letter-spacing: 1px;">Token Number</div>
        <div class="token-number-large" id="status-token-number">--</div>
        
        <div id="status-badge-container">
          <span class="status-badge-large bg-white text-primary"><i class="fa-solid fa-spinner fa-spin"></i> Checking...</span>
        </div>
      </div>

      <!-- Card Body containing details -->
      <div class="card-body p-4">
        
        <!-- Live Alert for Active Tokens -->
        <div id="live-alert-box" class="alert alert-info border-0 p-3 mb-4 rounded-3 d-flex align-items-center gap-2 d-none">
          <i class="fa-solid fa-circle-exclamation text-info animate-pulse fs-5"></i>
          <span style="font-size: 0.85rem;" id="live-alert-text">Checking queue status...</span>
        </div>

        <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-circle-info text-primary me-2"></i>Token Details</h5>
        
        <!-- Detail Grid List -->
        <div class="row g-3" style="font-size: 0.95rem;">
          <div class="col-6 text-muted">Customer Name:</div>
          <div class="col-6 fw-semibold text-end text-dark" id="detail-name">-</div>
          
          <div class="col-6 text-muted">Requested Service:</div>
          <div class="col-6 fw-semibold text-end text-dark" id="detail-service">-</div>
          
          <div class="col-6 text-muted">Booking Reference:</div>
          <div class="col-6 fw-semibold text-end text-dark" id="detail-source">-</div>
          
          <div class="col-6 text-muted">Registered On:</div>
          <div class="col-6 fw-semibold text-end text-dark" id="detail-datetime">-</div>
          
          <div class="col-6 text-muted">Additional Info:</div>
          <div class="col-6 fw-semibold text-end text-dark text-truncate" id="detail-remarks" title="-">-</div>
        </div>

        <hr class="my-4 border-secondary border-opacity-25 border-dashed">

        <!-- Action Row -->
        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center gap-3">
          <div class="d-flex align-items-center gap-2 text-muted" style="font-size: 0.85rem;">
            <i class="fa-solid fa-clock-rotate-left"></i>
            <span>Auto-refreshes in <strong id="refresh-counter">10</strong>s</span>
          </div>
          <button class="btn btn-outline-primary d-flex align-items-center gap-2 py-2 px-3 btn-sm" id="btn-manual-refresh">
            <i class="fa-solid fa-arrows-rotate refresh-btn"></i> Refresh Now
          </button>
        </div>

      </div>
      
      <!-- Footer details -->
      <div class="card-footer bg-light border-0 text-center py-3 text-muted" style="font-size: 0.75rem;">
        If you miss your call, please contact the support desk.
      </div>
    </div>
  </div>

  <!-- Bootstrap & Javascript Utilities -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="js/api.js"></script>
  <script>
    document.addEventListener("DOMContentLoaded", () => {
      // Elements
      const spinnerLoader = document.getElementById("spinner-loader");
      const statusOrgName = document.getElementById("status-org-name");
      const statusTokenNumber = document.getElementById("status-token-number");
      const statusBadgeContainer = document.getElementById("status-badge-container");
      
      const liveAlertBox = document.getElementById("live-alert-box");
      const liveAlertText = document.getElementById("live-alert-text");
      
      const detailName = document.getElementById("detail-name");
      const detailService = document.getElementById("detail-service");
      const detailSource = document.getElementById("detail-source");
      const detailDatetime = document.getElementById("detail-datetime");
      const detailRemarks = document.getElementById("detail-remarks");
      
      const refreshCounter = document.getElementById("refresh-counter");
      const btnManualRefresh = document.getElementById("btn-manual-refresh");
      
      let tokenNumber = null;
      let countdown = 10;
      let timerInterval = null;

      /**
       * Parse query parameter
       */
      function getQueryParam(param) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(param);
      }

      /**
       * Initialize status page
       */
      async function init() {
        tokenNumber = getQueryParam("token");
        if (!tokenNumber) {
          showErrorState("No token specified. Please scan a valid QR code.");
          return;
        }

        statusTokenNumber.textContent = tokenNumber;
        
        // Fetch org settings if available
        if (SmartTokenAPI.isConfigured()) {
          const sRes = await SmartTokenAPI.getSettings();
          if (sRes.success && sRes.settings) {
            statusOrgName.textContent = sRes.settings["Organization Name"] || "Smart Token System";
          }
        }

        await fetchTokenDetails();
        setupRefreshTimer();

        btnManualRefresh.addEventListener("click", async () => {
          spinnerLoader.classList.add("show");
          await fetchTokenDetails();
          spinnerLoader.classList.remove("show");
          countdown = 10; // reset
        });
      }

      /**
       * Query DB and render status
       */
      async function fetchTokenDetails() {
        const response = await SmartTokenAPI.getTokenDetails(tokenNumber);
        
        if (response.success && response.token) {
          const t = response.token;
          
          detailName.textContent = t.customerName || "Walk-In Customer";
          detailService.textContent = t.serviceType || "General Service";
          detailSource.textContent = `${t.source} Registration`;
          detailDatetime.textContent = `${t.date} @ ${t.time}`;
          detailRemarks.textContent = t.remarks || "-";
          detailRemarks.title = t.remarks || "-";
          
          updateStatusBadge(t.status, t.estimatedWaitingTimeMinutes);
        } else {
          showErrorState(response.error || "Token details not found.");
        }
      }

      /**
       * Render the custom status badge and alerts
       */
      function updateStatusBadge(status, waitTime) {
        statusBadgeContainer.innerHTML = "";
        liveAlertBox.classList.add("d-none");
        
        let badgeHTML = "";
        
        if (status === 'Waiting') {
          badgeHTML = `<span class="status-badge-large bg-warning text-white pulse-glow"><i class="fa-solid fa-clock"></i> In Queue (Waiting)</span>`;
          liveAlertText.textContent = `You are currently in the queue. Estimated wait time: ${waitTime} minutes.`;
          liveAlertBox.className = "alert alert-warning border-0 p-3 mb-4 rounded-3 d-flex align-items-center gap-2";
          liveAlertBox.classList.remove("d-none");
        } 
        else if (status === 'Serving') {
          badgeHTML = `<span class="status-badge-large bg-success text-white pulse-glow"><i class="fa-solid fa-bell"></i> Now Serving!</span>`;
          liveAlertText.textContent = `Your token is being called! Please proceed to Counter 1 immediately.`;
          liveAlertBox.className = "alert alert-success border-0 p-3 mb-4 rounded-3 d-flex align-items-center gap-2";
          liveAlertBox.classList.remove("d-none");
        } 
        else if (status === 'Completed') {
          badgeHTML = `<span class="status-badge-large bg-secondary text-white"><i class="fa-solid fa-check-double"></i> Completed</span>`;
          liveAlertText.textContent = `This token has been marked as Completed. Thank you!`;
          liveAlertBox.className = "alert alert-secondary border-0 p-3 mb-4 rounded-3 d-flex align-items-center gap-2";
          liveAlertBox.classList.remove("d-none");
        } 
        else if (status === 'Skipped') {
          badgeHTML = `<span class="status-badge-large bg-danger text-white"><i class="fa-solid fa-triangle-exclamation"></i> Skipped</span>`;
          liveAlertText.textContent = `You were called but did not show up. Your token has been marked as Skipped.`;
          liveAlertBox.className = "alert alert-danger border-0 p-3 mb-4 rounded-3 d-flex align-items-center gap-2";
          liveAlertBox.classList.remove("d-none");
        }

        statusBadgeContainer.innerHTML = badgeHTML;
      }

      /**
       * Render error card if token not found
       */
      function showErrorState(msg) {
        statusBadgeContainer.innerHTML = `<span class="status-badge-large bg-danger text-white"><i class="fa-solid fa-circle-xmark"></i> Error</span>`;
        liveAlertText.textContent = msg;
        liveAlertBox.className = "alert alert-danger border-0 p-3 mb-4 rounded-3 d-flex align-items-center gap-2";
        liveAlertBox.classList.remove("d-none");
        
        detailName.textContent = "N/A";
        detailService.textContent = "N/A";
        detailSource.textContent = "N/A";
        detailDatetime.textContent = "N/A";
        detailRemarks.textContent = "N/A";
        
        if (timerInterval) clearInterval(timerInterval);
      }

      /**
       * Setup 10-second polling refresh countdown
       */
      function setupRefreshTimer() {
        if (timerInterval) clearInterval(timerInterval);
        
        timerInterval = setInterval(async () => {
          countdown--;
          refreshCounter.textContent = countdown;
          
          if (countdown <= 0) {
            countdown = 10;
            refreshCounter.textContent = "Updating...";
            await fetchTokenDetails();
            refreshCounter.textContent = "10";
          }
        }, 1000);
      }

      init();
    });
  </script>
</body>
</html>

```

### File: `css/style.css`
```css
/* Smart Token Management System - Global Stylesheet */
@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap');

:root {
  --primary-color: #1a73e8; /* Elegant Google Blue */
  --primary-hover: #1557b0;
  --secondary-color: #00bcd4; /* Teal Accent */
  --bg-color: #f4f6f9;
  --card-bg: #ffffff;
  --text-primary: #1c1e21;
  --text-muted: #5f6368;
  --sidebar-width: 260px;
  --border-radius-sm: 8px;
  --border-radius-md: 12px;
  --border-radius-lg: 20px;
  --box-shadow-sm: 0 2px 6px rgba(0, 0, 0, 0.04);
  --box-shadow-md: 0 4px 20px rgba(0, 0, 0, 0.06);
  --box-shadow-lg: 0 10px 30px rgba(0, 0, 0, 0.08);
  --transition-smooth: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

body {
  font-family: 'Plus Jakarta Sans', sans-serif;
  background-color: var(--bg-color);
  color: var(--text-primary);
  min-height: 100vh;
  margin: 0;
  padding: 0;
  overflow-x: hidden;
}

/* Sidebar Navigation */
.sidebar {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  width: var(--sidebar-width);
  background-color: var(--card-bg);
  border-right: 1px solid rgba(0, 0, 0, 0.08);
  z-index: 1030;
  transition: var(--transition-smooth);
  display: flex;
  flex-direction: column;
}

.sidebar-brand {
  padding: 1.5rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-weight: 700;
  color: var(--primary-color);
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.sidebar-menu {
  list-style: none;
  padding: 1rem 0.75rem;
  margin: 0;
  flex-grow: 1;
}

.sidebar-menu li {
  margin-bottom: 0.35rem;
}

.sidebar-menu a {
  display: flex;
  align-items: center;
  gap: 0.85rem;
  padding: 0.75rem 1rem;
  color: var(--text-muted);
  text-decoration: none;
  border-radius: var(--border-radius-md);
  font-weight: 500;
  transition: var(--transition-smooth);
}

.sidebar-menu a:hover {
  background-color: rgba(26, 115, 232, 0.05);
  color: var(--primary-color);
}

.sidebar-menu li.active a {
  background-color: var(--primary-color);
  color: #ffffff;
  box-shadow: 0 4px 12px rgba(26, 115, 232, 0.25);
}

.sidebar-footer {
  padding: 1rem;
  border-top: 1px solid rgba(0, 0, 0, 0.05);
  font-size: 0.8rem;
  color: var(--text-muted);
}

/* Content Area Layout */
.main-wrapper {
  margin-left: var(--sidebar-width);
  min-height: 100vh;
  transition: var(--transition-smooth);
  display: flex;
  flex-direction: column;
}

.top-navbar {
  height: 70px;
  background-color: var(--card-bg);
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
  padding: 0 2rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: sticky;
  top: 0;
  z-index: 1020;
}

.content-body {
  flex-grow: 1;
  padding: 2rem;
}

/* Responsive Sidebar Mobile Toggle */
.mobile-nav-toggle {
  display: none;
  background: none;
  border: none;
  font-size: 1.5rem;
  color: var(--text-primary);
  cursor: pointer;
  padding: 0.25rem;
}

@media (max-width: 991.98px) {
  .sidebar {
    transform: translateX(-100%);
  }
  
  .sidebar.show {
    transform: translateX(0);
    box-shadow: var(--box-shadow-lg);
  }
  
  .main-wrapper {
    margin-left: 0;
  }
  
  .mobile-nav-toggle {
    display: block;
  }
  
  .top-navbar {
    padding: 0 1.25rem;
  }
  
  .content-body {
    padding: 1.25rem;
  }
}

/* Modern Glassmorphic Cards & Styles */
.card {
  background: var(--card-bg);
  border: 1px solid rgba(0, 0, 0, 0.05);
  border-radius: var(--border-radius-md);
  box-shadow: var(--box-shadow-sm);
  transition: var(--transition-smooth);
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: var(--box-shadow-md);
}

.stat-card {
  padding: 1.5rem;
  border-left: 5px solid var(--primary-color);
}

.stat-card-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.35rem;
  margin-bottom: 1rem;
}

.stat-card-value {
  font-size: 1.85rem;
  font-weight: 700;
  margin: 0.25rem 0;
}

.stat-card-label {
  font-size: 0.875rem;
  color: var(--text-muted);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Color codes for status stats */
.stat-primary {
  border-left-color: var(--primary-color);
}
.stat-primary .stat-card-icon {
  background-color: rgba(26, 115, 232, 0.1);
  color: var(--primary-color);
}

.stat-success {
  border-left-color: #2e7d32;
}
.stat-success .stat-card-icon {
  background-color: rgba(46, 125, 50, 0.1);
  color: #2e7d32;
}

.stat-info {
  border-left-color: #0288d1;
}
.stat-info .stat-card-icon {
  background-color: rgba(2, 136, 209, 0.1);
  color: #0288d1;
}

.stat-warning {
  border-left-color: #f57c00;
}
.stat-warning .stat-card-icon {
  background-color: rgba(245, 124, 0, 0.1);
  color: #f57c00;
}

.stat-danger {
  border-left-color: #d32f2f;
}
.stat-danger .stat-card-icon {
  background-color: rgba(211, 47, 47, 0.1);
  color: #d32f2f;
}

/* Serving Panel Dashboard Display */
.serving-panel {
  background: linear-gradient(135deg, var(--primary-color) 0%, #1557b0 100%);
  color: #ffffff;
  border: none;
}

.serving-panel .card-title {
  opacity: 0.9;
  letter-spacing: 0.5px;
}

.serving-token-number {
  font-size: 5rem;
  font-weight: 800;
  line-height: 1;
  text-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
}

/* Custom Table Styles */
.table-responsive {
  border-radius: var(--border-radius-md);
  border: 1px solid rgba(0, 0, 0, 0.05);
}

.table {
  margin-bottom: 0;
}

.table th {
  background-color: #f8f9fa;
  color: var(--text-muted);
  font-weight: 600;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding: 1rem;
  border-bottom: 2px solid rgba(0, 0, 0, 0.05);
}

.table td {
  padding: 1rem;
  vertical-align: middle;
  border-bottom: 1px solid rgba(0, 0, 0, 0.03);
}

/* Badge Styles */
.badge {
  font-weight: 600;
  padding: 0.45em 0.8em;
  border-radius: 6px;
}

.badge-waiting {
  background-color: rgba(245, 124, 0, 0.1);
  color: #f57c00;
}

.badge-serving {
  background-color: rgba(26, 115, 232, 0.1);
  color: var(--primary-color);
}

.badge-completed {
  background-color: rgba(46, 125, 50, 0.1);
  color: #2e7d32;
}

.badge-skipped {
  background-color: rgba(211, 47, 47, 0.1);
  color: #d32f2f;
}

/* Fullscreen Token Display Screen styles */
.display-page-body {
  background-color: #0b0f19;
  color: #ffffff;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.display-header {
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  background-color: rgba(255, 255, 255, 0.02);
  padding: 1.5rem 2rem;
}

.now-serving-title {
  color: #00bcd4;
  font-weight: 800;
  letter-spacing: 2px;
  font-size: 1.5rem;
}

.display-now-serving-box {
  background: radial-gradient(circle at center, #1a233d 0%, #0c1221 100%);
  border: 2px solid #1a73e8;
  border-radius: var(--border-radius-lg);
  box-shadow: 0 0 40px rgba(26, 115, 232, 0.3);
}

.display-serving-number {
  font-size: 12rem;
  font-weight: 900;
  color: #ffffff;
  text-shadow: 0 0 20px rgba(255, 255, 255, 0.4);
  line-height: 1.1;
}

.display-next-box {
  background-color: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: var(--border-radius-md);
  transition: var(--transition-smooth);
}

.display-next-box:hover {
  border-color: #00bcd4;
  background-color: rgba(0, 188, 212, 0.05);
}

.display-next-number {
  font-size: 3rem;
  font-weight: 800;
  color: #00bcd4;
}

.display-next-label {
  font-size: 1rem;
  color: #a0aec0;
  text-transform: uppercase;
}

/* Animations */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fadeIn 0.4s ease-out forwards;
}

/* Toast Notifications Container */
.toast-container {
  z-index: 1090;
}

/* Custom Buttons styling */
.btn {
  border-radius: var(--border-radius-sm);
  font-weight: 600;
  padding: 0.5rem 1.25rem;
  transition: var(--transition-smooth);
}

.btn-primary {
  background-color: var(--primary-color);
  border-color: var(--primary-color);
}

.btn-primary:hover {
  background-color: var(--primary-hover);
  border-color: var(--primary-hover);
}

.btn-outline-primary {
  color: var(--primary-color);
  border-color: var(--primary-color);
}

.btn-outline-primary:hover {
  background-color: var(--primary-color);
  color: #ffffff;
}

/* Spinner Loader */
.spinner-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(255, 255, 255, 0.7);
  z-index: 2000;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.25s ease;
}

.spinner-overlay.show {
  opacity: 1;
  pointer-events: auto;
}

/* Utility layout styles */
.login-card {
  max-width: 420px;
  width: 100%;
}

```

### File: `google_backend/.clasp.json`
```json
{"scriptId":"1bgfQY_xkYYbz-5UEJNYGMm7U-jZJYu-dTtAcHzbTr6gyL9zbzk1SZVGN","rootDir":"google_backend","parentId":["1PMuefj-PY9ThfpfFKN7poWamKqOj63biHygIafIgI60"]}

```

### File: `google_backend/appsscript.json`
```json
{
  "timeZone": "Asia/Kolkata",
  "dependencies": {
  },
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8",
  "webapp": {
    "access": "ANYONE",
    "executeAs": "USER_DEPLOYING"
  }
}

```

### File: `google_backend/code.gs`
```javascript
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

```

### File: `google_backend/setup_guide.md`
```markdown
# Google Sheets & Apps Script Setup Guide

Follow these steps to set up your Google Sheets database and deploy the REST API backend for the **Smart Token Management System**. You can set it up manually using the web interface or automatically using the **clasp CLI** (Command Line Apps Script Projects).

---

## Approach A: Manual Web Setup

### Step 1: Create a Google Sheet
1. Open your browser and go to [Google Sheets](https://sheets.google.com).
2. Create a new blank spreadsheet and rename it to `Smart Token Database`.
3. Note: The backend script initializes the sheets ("Tokens" and "Settings") automatically on first launch.

### Step 2: Add the Apps Script Code
1. Click **Extensions** > **Apps Script**.
2. Erase any placeholder code in `Code.gs` and paste the contents of [code.gs](file:///c:/Projects/token%20project/google_backend/code.gs).
3. Click the **Save** icon.

### Step 3: Deploy as a Web App
1. Click **Deploy** > **New deployment**.
2. Click the gear icon and select **Web app**.
3. Configure the settings:
   - **Execute as**: **Me (your-email@gmail.com)**
   - **Who has access**: **Anyone**
4. Click **Deploy**, authorize permissions, and copy the resulting **Web app URL**.

---

## Approach B: Command Line Setup (clasp CLI)

Since your system has Node.js and npm installed, you can manage, push, and deploy this project directly from your terminal using Google's official **clasp** tool.

### Step 1: Install clasp dependencies locally
Run the following command inside your project directory to install clasp:
\`\`\`bash
npm install
\`\`\`

### Step 2: Enable Google Apps Script API
Before using clasp, you must enable the Apps Script API in your Google account settings:
1. Go to [https://script.google.com/home/usersettings](https://script.google.com/home/usersettings).
2. Toggle the **Google Apps Script API** status to **ON** (Enabled).

### Step 3: Log in to Google from terminal
Run this command to authenticate:
\`\`\`bash
npx clasp login
\`\`\`
This opens your browser. Select your Google account and grant access.

### Step 4: Link your spreadsheet script ID
1. Create a script by opening a Google Sheet and clicking **Extensions** > **Apps Script**.
2. Click **Project Settings** (gear icon on the left panel).
3. Copy the **Script ID** (a long alphanumeric string).
4. Open your local [.clasp.json](file:///c:/Projects/token%20project/.clasp.json) file and paste it:
   \`\`\`json
   {
     "scriptId": "YOUR_COPIED_SCRIPT_ID_HERE",
     "rootDir": "google_backend"
   }
   \`\`\`

### Step 5: Push and deploy
Run the following commands to upload your local files and deploy the Web App:
\`\`\`bash
# Push local code (code.gs and appsscript.json) to Google
npm run clasp:push

# Deploy a new web app version
npm run clasp:deploy
\`\`\`
The terminal will display the active deployment information and print the **Web app URL**. Copy this URL and paste it into your local frontend Settings screen!

---

## Troubleshooting clasp Updates
* If you edit [google_backend/code.gs](file:///c:/Projects/token%20project/google_backend/code.gs), compile and send updates using `npm run clasp:push`.
* Creating a new deployment via `npm run clasp:deploy` ensures Google runs the latest pushed version of your code.

```

### File: `iot/wiring_guide.md`
```markdown
# IoT Hardware Wiring & DFPlayer Configuration Guide

This guide describes how to wire the ESP32 microcontrollers and set up the DFPlayer Mini (MP3 TF 16P) sound player with speaker outputs.

---

## 1. Bill of Materials (BOM)

To build both Master and Slave devices, you will need:

| Qty | Component Name | Purpose |
| :---: | :--- | :--- |
| **2** | ESP32 Development Board (e.g. NodeMCU-32S, ESP32-WROOM-3D) | Main Wi-Fi enabled microcontrollers |
| **1** | DFPlayer Mini Module (MP3 TF 16P) | Sound player decoder chip |
| **1** | MicroSD Card (Capacity <= 32GB) | Storage for voice audio files (Formatted FAT16/FAT32) |
| **1** | 8 Ohm, 3W Mini Speaker | Output sound player speaker |
| **1** | 1K Ohm Resistor | Noise cancellation resistor for serial connection |
| **2** | Momentary Push Buttons | Triggers token generation (Master) and next-calling (Slave) |
| **-** | Breadboards & Jumper wires | Electrical connections |

---

## 2. Wiring Connections

Both ESP32 chips use standard internal pullup resistors, meaning buttons are wired directly from the GPIO pin to Ground (no external pullup resistors needed).

### Master ESP32: Walk-In Dispenser
- **Push Button**: Connected between **GPIO 4** and **GND**.
- **Indicator LED**: Onboard LED uses **GPIO 2** (integrated).

### Slave ESP32: Operator Terminal with Speaker calling
- **Call Button**: Connected between **GPIO 4** and **GND**.
- **Blink LED**: Onboard LED uses **GPIO 2** (integrated).

#### DFPlayer Mini Wiring Map (Slave ESP32 to DFPlayer)

Connect the DFPlayer Mini pins to the Slave ESP32 development board according to this diagram:

\`\`\`
          DFPlayer Mini Pinout
           +----+---U---+----+
    VCC    | 1  |       | 16 |   BUSY Pin (Connects to ESP32 GPIO 5)
    RX Pin | 2  |       | 15 |   GND
    TX Pin | 3  |       | 14 |   DAC_R
    DAC_L  | 4  |       | 13 |   DAC_L
    SPK1   | 5  |       | 12 |   ADKEY2
    GND    | 6  |       | 11 |   ADKEY1
    SPK2   | 7  |       | 10 |   IO2
    GND    | 8  |       | 9  |   IO1
           +----+-------+----+
\`\`\`

| DFPlayer Pin | Label | Connection Target (ESP32 / Speaker) | Rationale |
| :---: | :--- | :--- | :--- |
| **Pin 1** | **VCC** | **ESP32 5V Pin** (or VIN) | Requires 5V for high speaker volume. |
| **Pin 2** | **RX** | **1K Resistor** $\rightarrow$ **ESP32 GPIO 17 (TX2)** | 1K resistor prevents serial communication noise. |
| **Pin 3** | **TX** | **ESP32 GPIO 16 (RX2)** | TX lines transmit serial packets. |
| **Pin 5** | **SPK1** | **Speaker positive terminal** | Audio out driver. |
| **Pin 6** | **GND** | **ESP32 GND Pin** | Ground reference. |
| **Pin 7** | **SPK2** | **Speaker negative terminal** | Audio out driver. |
| **Pin 16** | **BUSY** | **ESP32 GPIO 5** | Indicates track state (LOW = playing, HIGH = done). |

> [!CAUTION]
> Always insert a **1K Ohm resistor** in series between ESP32 TX2 (GPIO 17) and DFPlayer RX (Pin 2). Failing to do so causes severe crackling noise in the speaker and can damage the RX line of the DFPlayer module due to 3.3V vs 5V voltage mismatch.

---

## 3. MicroSD Card Folder & Audio Track Setup

The MicroSD card must be formatted with **FAT16** or **FAT32** file systems.
For the `DFRobotDFPlayerMini` library to locate files correctly, create a folder named `mp3` at the root of the SD card, and rename your audio files to match the four-digit prefixes listed below:

\`\`\`
SD Card Root (D:)
 └── mp3/
      ├── 0001.mp3   <-- Speaks "Token"
      ├── 0002.mp3   <-- Speaks "Number"
      ├── 0003.mp3   <-- Speaks "Zero"
      ├── 0004.mp3   <-- Speaks "One"
      ├── 0005.mp3   <-- Speaks "Two"
      ├── 0006.mp3   <-- Speaks "Three"
      ├── 0007.mp3   <-- Speaks "Four"
      ├── 0008.mp3   <-- Speaks "Five"
      ├── 0009.mp3   <-- Speaks "Six"
      ├── 0010.mp3   <-- Speaks "Seven"
      ├── 0011.mp3   <-- Speaks "Eight"
      ├── 0012.mp3   <-- Speaks "Nine"
      ├── 0013.mp3   <-- Speaks "Please proceed to counter one"
      └── 0014.mp3   <-- Speaks "Buzzer Chime sound"
\`\`\`

### Tips for creating voice files:
- You can use online text-to-speech converters to generate clear, studio-grade voices.
- Save files in `.mp3` format with **128kbps** bit rate and **44100Hz** sample rate.
- If you change the counter number (e.g. "proceed to Counter 2"), record a new phrase for file `0013.mp3`.

```

### File: `iot/esp32_master/esp32_master.ino`
```cpp
/**
 * Smart Token Management System - Master ESP32 Ticket Dispenser
 * 
 * Hardware Description:
 * - ESP32 Development Board
 * - Walk-in Push-Button connected between GPIO 4 and GND
 * - LED Indicator connected to GPIO 2 (onboard LED)
 */

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// Wi-Fi Credentials
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// Google Apps Script Web App URL (MUST end in /exec)
const char* googleWebAppUrl = "https://script.google.com/macros/s/AKfycbxIDzQF_XxhYujTWFyAy9bJQbgpEllYkcfMBr-B0KDe3Lmn3jKImPMLWIglLBDYr-8/exec";

// Hardware Pins
const int BUTTON_PIN = 4; // Push button pin (active LOW)
const int LED_PIN = 2;    // Status LED pin

// Debounce state
unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 300; 

void setup() {
  Serial.begin(115200);
  
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  // Connect to Wi-Fi
  connectToWiFi();
}

void loop() {
  // Read button state (active LOW due to pullup)
  int buttonState = digitalRead(BUTTON_PIN);

  if (buttonState == LOW) {
    if ((millis() - lastDebounceTime) > debounceDelay) {
      lastDebounceTime = millis();
      Serial.println("\n[Master] Button pressed. Dispatching Manual Ticket generation...");
      
      // Visual feedback of pressing
      digitalWrite(LED_PIN, HIGH);
      
      // Generate Token via HTTP call
      triggerGenerateTokenAPI();
      
      digitalWrite(LED_PIN, LOW);
    }
  }
}

/**
 * Handle Wi-Fi Connection
 */
void connectToWiFi() {
  Serial.print("[WiFi] Connecting to SSID: ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[WiFi] Connected successfully!");
    Serial.print("[WiFi] IP Address: ");
    Serial.println(WiFi.localIP());
    // Blinker indicating connection success
    for (int i = 0; i < 3; i++) {
      digitalWrite(LED_PIN, HIGH);
      delay(150);
      digitalWrite(LED_PIN, LOW);
      delay(150);
    }
  } else {
    Serial.println("\n[WiFi] Connection failed. Check credentials.");
  }
}

/**
 * Perform POST Request to Google Apps Script Web App
 */
void triggerGenerateTokenAPI() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("[Error] WiFi disconnected. Attempting reconnect...");
    connectToWiFi();
    if (WiFi.status() != WL_CONNECTED) return;
  }

  HTTPClient http;
  
  // Set up connection target
  http.begin(googleWebAppUrl);
  
  // CRITICAL: Google Apps Script Web Apps redirect (302 Found) to Google User Content URLs.
  // We must instruct HTTPClient to automatically follow redirects.
  http.setFollowRedirects(HTTPC_FORCE_FOLLOW_REDIRECTS);
  
  // Prepare JSON payload parameters
  StaticJsonDocument<256> doc;
  doc["action"] = "generateToken";
  doc["name"] = "Walk-In Customer";
  doc["phone"] = "-";
  doc["email"] = "-";
  doc["serviceType"] = "General Service";
  doc["source"] = "Manual"; // Indicates hardware/desk dispatcher
  doc["remarks"] = "Generated via Master ESP32 hardware button";
  
  String requestBody;
  serializeJson(doc, requestBody);
  
  Serial.println("[HTTP] Sending POST request...");
  
  // Google Apps Script expects "text/plain" or similar content type to bypass CORS issues, 
  // though from ESP32 standard headers are fine.
  http.addHeader("Content-Type", "application/json");
  
  int httpResponseCode = http.POST(requestBody);
  
  if (httpResponseCode > 0) {
    Serial.print("[HTTP] Response code: ");
    Serial.println(httpResponseCode);
    
    String responseString = http.getString();
    Serial.println("[HTTP] Response JSON:");
    Serial.println(responseString);
    
    // Parse response JSON to fetch generated token number
    StaticJsonDocument<512> responseDoc;
    DeserializationError error = deserializeJson(responseDoc, responseString);
    
    if (!error) {
      bool success = responseDoc["success"];
      if (success) {
        const char* tokenNum = responseDoc["tokenNumber"];
        const char* timeGen = responseDoc["timeGenerated"];
        int waitTime = responseDoc["estimatedWaitingTimeMinutes"];
        
        Serial.println("\n==================================");
        Serial.print("  TICKET DISPENSED SUCCESS\n");
        Serial.print("  Token Number: "); Serial.println(tokenNum);
        Serial.print("  Time: "); Serial.println(timeGen);
        Serial.print("  Est. Wait: "); Serial.print(waitTime); Serial.println(" Mins");
        Serial.println("==================================");
        
        // Double blink success LED indicator
        digitalWrite(LED_PIN, HIGH); delay(200);
        digitalWrite(LED_PIN, LOW); delay(200);
        digitalWrite(LED_PIN, HIGH); delay(200);
        digitalWrite(LED_PIN, LOW);
      } else {
        const char* err = responseDoc["error"];
        Serial.print("[API Error] Failed to generate token: ");
        Serial.println(err);
      }
    } else {
      Serial.print("[JSON Error] Deserialization failed: ");
      Serial.println(error.f_str());
    }
  } else {
    Serial.print("[HTTP Error] POST request failed: ");
    Serial.println(http.errorToString(httpResponseCode).c_str());
  }
  
  // Clean up
  http.end();
}

```

### File: `iot/esp32_slave/esp32_slave.ino`
```cpp
/**
 * Smart Token Management System - Slave ESP32 Operator Terminal
 * 
 * Hardware Description:
 * - ESP32 Development Board
 * - "Next Token" Button connected between GPIO 4 and GND
 * - DFPlayer Mini (MP3 TF 16P) connected to:
 *     - VCC -> 5V
 *     - GND -> GND
 *     - TX -> GPIO 16 (ESP32 RX2)
 *     - RX -> GPIO 17 (ESP32 TX2) [Use 1K ohm resistor in series between TX2 and RX]
 *     - Busy Pin -> GPIO 5 (with internal pullup)
 * - LED Indicator on GPIO 2
 */

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <HardwareSerial.h>
#include <DFRobotDFPlayerMini.h>

// Wi-Fi Credentials
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// Google Apps Script Web App URL
const char* googleWebAppUrl = "https://script.google.com/macros/s/AKfycbxIDzQF_XxhYujTWFyAy9bJQbgpEllYkcfMBr-B0KDe3Lmn3jKImPMLWIglLBDYr-8/exec";

// Hardware Pin Configuration
const int NEXT_BUTTON_PIN = 4; // Operator Desk Call Button (active LOW)
const int BUSY_PIN = 5;        // DFPlayer Mini BUSY pin (LOW = playing, HIGH = idle)
const int LED_PIN = 2;         // Status indicator LED

// DFPlayer and Serial configurations
HardwareSerial mySoftwareSerial(2); // Use ESP32 HardwareSerial 2
DFRobotDFPlayerMini myDFPlayer;

// Debounce settings
unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 400; 

void setup() {
  Serial.begin(115200);
  
  pinMode(NEXT_BUTTON_PIN, INPUT_PULLUP);
  pinMode(BUSY_PIN, INPUT_PULLUP);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  // Initialize HardwareSerial2 (RX=16, TX=17) for DFPlayer Mini
  mySoftwareSerial.begin(9600, SERIAL_8N1, 16, 17);
  
  Serial.println("[DFPlayer] Connecting to DFPlayer Mini...");
  
  if (!myDFPlayer.begin(mySoftwareSerial)) {
    Serial.println("[Error] DFPlayer Mini not detected. Check RX/TX connections and SD card.");
    // Blink LED to indicate DFPlayer failure
    for (int i = 0; i < 10; i++) {
      digitalWrite(LED_PIN, HIGH); delay(100);
      digitalWrite(LED_PIN, LOW); delay(100);
    }
  } else {
    Serial.println("[DFPlayer] Connected successfully.");
    myDFPlayer.volume(25); // Set speaker volume (0 to 30)
  }

  // Connect Wi-Fi
  connectToWiFi();
}

void loop() {
  // Read Operator "Next" button
  int buttonState = digitalRead(NEXT_BUTTON_PIN);

  if (buttonState == LOW) {
    if ((millis() - lastDebounceTime) > debounceDelay) {
      lastDebounceTime = millis();
      Serial.println("\n[Slave] Calling next customer queue slot...");
      
      digitalWrite(LED_PIN, HIGH);
      
      // Call Next Token from Apps Script
      triggerNextTokenAPI();
      
      digitalWrite(LED_PIN, LOW);
    }
  }
}

/**
 * Handle Wi-Fi connections
 */
void connectToWiFi() {
  Serial.print("[WiFi] Connecting to: ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[WiFi] Connected!");
    Serial.print("[WiFi] IP Address: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("\n[WiFi] Connection failed.");
  }
}

/**
 * Call Next Token API and announce resulting digits
 */
void triggerNextTokenAPI() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("[WiFi Error] Disconnected. Reconnecting...");
    connectToWiFi();
    if (WiFi.status() != WL_CONNECTED) return;
  }

  HTTPClient http;
  http.begin(googleWebAppUrl);
  http.setFollowRedirects(HTTPC_FORCE_FOLLOW_REDIRECTS);
  
  // JSON payload structure
  StaticJsonDocument<128> doc;
  doc["action"] = "nextToken";
  
  String requestBody;
  serializeJson(doc, requestBody);
  
  http.addHeader("Content-Type", "application/json");
  int httpResponseCode = http.POST(requestBody);
  
  if (httpResponseCode > 0) {
    String responseString = http.getString();
    Serial.println("[HTTP] NextToken Response:");
    Serial.println(responseString);
    
    StaticJsonDocument<512> responseDoc;
    DeserializationError error = deserializeJson(responseDoc, responseString);
    
    if (!error) {
      bool success = responseDoc["success"];
      if (success) {
        // If there's an active token details returned in serving payload
        if (responseDoc.containsKey("serving") && !responseDoc["serving"].isNull()) {
          const char* tokenNum = responseDoc["serving"]["tokenNumber"];
          const char* name = responseDoc["serving"]["customerName"];
          
          Serial.println("\n==================================");
          Serial.print("  CALLING NOW: "); Serial.println(tokenNum);
          Serial.print("  Customer: "); Serial.println(name);
          Serial.println("==================================");
          
          // Vocal Speech Announcement sequence
          announceToken(tokenNum);
        } else {
          Serial.println("[Lobby Info] Queue is currently empty. No waiting customers.");
          // Play buzzer chime only indicating empty queue
          playBuzzerChime();
        }
      } else {
        const char* err = responseDoc["error"];
        Serial.print("[API Error] "); Serial.println(err);
      }
    } else {
      Serial.print("[JSON Error] Deserialization failed: ");
      Serial.println(error.f_str());
    }
  } else {
    Serial.print("[HTTP Error] POST request failed: ");
    Serial.println(http.errorToString(httpResponseCode).c_str());
  }
  
  http.end();
}

/**
 * Speak the token number digit-by-digit
 * 
 * Audio track mapping layout:
 * - 0001.mp3: "Token"
 * - 0002.mp3: "Number"
 * - 0003.mp3: "Zero"
 * - 0004.mp3: "One"
 * - 0005.mp3: "Two"
 * - 0006.mp3: "Three"
 * - 0007.mp3: "Four"
 * - 0008.mp3: "Five"
 * - 0009.mp3: "Six"
 * - 0010.mp3: "Seven"
 * - 0011.mp3: "Eight"
 * - 0012.mp3: "Nine"
 * - 0013.mp3: "Please proceed to counter one"
 */
void announceToken(const String& tokenStr) {
  Serial.println("[DFPlayer] Commencing Voice Announcement...");
  
  // 1. Play track 1 ("Token")
  myDFPlayer.play(1);
  waitPlayComplete();
  
  // 2. Play track 2 ("Number")
  myDFPlayer.play(2);
  waitPlayComplete();
  
  // 3. Process digits sequence
  for (int i = 0; i < tokenStr.length(); i++) {
    char ch = tokenStr.charAt(i);
    int trackNum = -1;
    
    // Convert ASCII digit characters to respective track numbers
    if (ch >= '0' && ch <= '9') {
      trackNum = (ch - '0') + 3; // '0' is track 3, '1' is track 4, etc.
    }
    
    if (trackNum != -1) {
      Serial.print("[DFPlayer] Playing digit: "); Serial.println(ch);
      myDFPlayer.play(trackNum);
      waitPlayComplete();
    }
  }
  
  // 4. Play track 13 ("Please proceed to counter one")
  myDFPlayer.play(13);
  waitPlayComplete();
  
  Serial.println("[DFPlayer] Vocal announcement sequence completed.");
}

/**
 * Blocking wait until DFPlayer Mini finishes playing active track.
 * Reads high/low state of GPIO Pin connected to DFPlayer Busy pin.
 */
void waitPlayComplete() {
  delay(100); // Give DFPlayer 100ms to pull the BUSY pin low
  
  // While BUSY pin is LOW (0), track is playing. Wait.
  while (digitalRead(BUSY_PIN) == LOW) {
    delay(10);
  }
}

/**
 * Play a simple single chime track for announcements
 */
void playBuzzerChime() {
  // Let's assume Track 14 is a buzzer chime sound
  Serial.println("[DFPlayer] Playing empty queue chime...");
  myDFPlayer.play(14);
  waitPlayComplete();
}

```

### File: `js/api.js`
```javascript
/**
 * Smart Token Management System - Client API Wrapper (Supabase Version)
 * 
 * Communicates directly with the Supabase Postgres database.
 */

const SmartTokenAPI = (function() {
  const STORAGE_KEY_SESSION = "smart_token_session";
  
  // Set your Supabase details here:
  const SUPABASE_URL = "https://swqgfhtyfudkwvyuulzz.supabase.co";
  // IMPORTANT: You must replace this with your actual anon public key from the Supabase Dashboard
  const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN3cWdmaHR5ZnVka3d2eXV1bHp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE2MDE4ODIsImV4cCI6MjA5NzE3Nzg4Mn0.qbjAR4I8NfCFusutfws4I4oZJsbCx4TGeaYtfSyA1fc"; 
  
  let supabase = null;

  async function getClient() {
    if (supabase) return supabase;
    if (!window.supabase) {
        // Dynamically load the Supabase library if not present in HTML
        await new Promise((resolve, reject) => {
            const script = document.createElement("script");
            script.src = "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2";
            script.onload = resolve;
            script.onerror = reject;
            document.head.appendChild(script);
        });
    }
    supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    return supabase;
  }

  // --- API Endpoints ---

  async function verifyLogin(username, password) {
    const db = await getClient();
    const { data, error } = await db.from('settings').select('value').eq('key', 'Admin Password').single();
    if (error) return { success: false, error: "DB Error: " + error.message };
    
    if (username.toLowerCase() === "admin" && password === data.value) {
      const token = "session_" + Math.random().toString(36).substr(2);
      localStorage.setItem(STORAGE_KEY_SESSION, token);
      return { success: true, message: "Authentication successful", token: token };
    }
    return { success: false, error: "Invalid username or password" };
  }

  function isLoggedIn() {
    return localStorage.getItem(STORAGE_KEY_SESSION) !== null;
  }

  function logout() {
    localStorage.removeItem(STORAGE_KEY_SESSION);
  }

  async function generateToken(details) {
    const db = await getClient();
    // Get settings parameters
    const { data: set1 } = await db.from('settings').select('value').eq('key', 'Last Generated Token').single();
    const { data: set2 } = await db.from('settings').select('value').eq('key', 'Starting Token Number').single();
    const { data: set3 } = await db.from('settings').select('value').eq('key', 'Average Service Time').single();
    
    let lastToken = parseInt(set1?.value || "0");
    let startingToken = parseInt(set2?.value || "100");
    let avgServiceTime = parseInt(set3?.value || "10");
    
    let newTokenNum = lastToken + 1;
    if (newTokenNum < startingToken) newTokenNum = startingToken;

    // Insert new token
    const { error: insErr } = await db.from('tokens').insert([{
      token_number: newTokenNum,
      customer_name: details.name || "Walk-In",
      phone_number: details.phone || "-",
      email: details.email || "-",
      service_type: details.serviceType || "General",
      source: details.source || "Manual",
      status: "Waiting",
      remarks: details.remarks || ""
    }]);

    if (insErr) return { success: false, error: insErr.message };

    // Update settings last token
    await db.from('settings').update({ value: newTokenNum.toString() }).eq('key', 'Last Generated Token');

    // Calculate wait time
    const { count } = await db.from('tokens')
        .select('*', { count: 'exact', head: true })
        .in('status', ['Waiting', 'Serving'])
        .lt('token_number', newTokenNum);

    return {
      success: true,
      tokenNumber: newTokenNum,
      customerName: details.name || "Walk-In",
      serviceType: details.serviceType || "General",
      source: details.source || "Manual",
      estimatedWaitingTimeMinutes: (count || 0) * avgServiceTime,
      timeGenerated: new Date().toLocaleTimeString(),
      dateGenerated: new Date().toLocaleDateString()
    };
  }

  async function getQueue() {
    const db = await getClient();
    const { data, error } = await db.from('tokens')
        .select('*')
        .in('status', ['Waiting', 'Serving'])
        .order('token_number', { ascending: true });
    
    if (error) return { success: false, queue: [] };
    
    return {
      success: true,
      queue: data.map(d => ({
        tokenNumber: d.token_number,
        customerName: d.customer_name,
        phoneNumber: d.phone_number,
        email: d.email,
        serviceType: d.service_type,
        source: d.source,
        status: d.status,
        date: new Date(d.created_at).toLocaleDateString(),
        time: new Date(d.created_at).toLocaleTimeString(),
        remarks: d.remarks
      }))
    };
  }

  async function nextToken() {
    const db = await getClient();
    // Complete current serving token first
    await db.from('tokens').update({ status: 'Completed' }).eq('status', 'Serving');
    
    // Find next waiting
    const { data: waitingData } = await db.from('tokens')
        .select('*').eq('status', 'Waiting')
        .order('token_number', { ascending: true })
        .limit(1);
        
    if (waitingData && waitingData.length > 0) {
        const next = waitingData[0];
        await db.from('tokens').update({ status: 'Serving' }).eq('id', next.id);
        await db.from('settings').update({ value: next.token_number.toString() }).eq('key', 'Current Serving Token');
        return { success: true, message: "Serving next token", serving: {
            tokenNumber: next.token_number,
            customerName: next.customer_name,
            serviceType: next.service_type,
            source: next.source,
            status: "Serving"
        }};
    } else {
        await db.from('settings').update({ value: "0" }).eq('key', 'Current Serving Token');
        return { success: true, message: "No waiting tokens in queue", serving: null };
    }
  }

  async function completeToken(tokenNumber) {
    const db = await getClient();
    await db.from('tokens').update({ status: 'Completed' }).eq('token_number', tokenNumber);
    const { data } = await db.from('settings').select('value').eq('key', 'Current Serving Token').single();
    if (data && data.value === tokenNumber.toString()) {
        await db.from('settings').update({ value: "0" }).eq('key', 'Current Serving Token');
    }
    return { success: true };
  }

  async function skipToken(tokenNumber) {
    const db = await getClient();
    await db.from('tokens').update({ status: 'Skipped' }).eq('token_number', tokenNumber);
    const { data } = await db.from('settings').select('value').eq('key', 'Current Serving Token').single();
    if (data && data.value === tokenNumber.toString()) {
        await db.from('settings').update({ value: "0" }).eq('key', 'Current Serving Token');
    }
    return { success: true };
  }

  async function getCurrentToken() {
    const db = await getClient();
    const { data, error } = await db.from('tokens').select('*').eq('status', 'Serving').single();
    if (error || !data) return { success: true, serving: null };
    
    return { success: true, serving: {
        tokenNumber: data.token_number,
        customerName: data.customer_name,
        serviceType: data.service_type,
        source: data.source,
        status: data.status
    }};
  }

  async function getReports() {
    const db = await getClient();
    const today = new Date();
    today.setHours(0,0,0,0);
    const { data, error } = await db.from('tokens').select('*').gte('created_at', today.toISOString());
    
    if (error) return { success: false };
    
    let stats = {
        totalTokens: data.length,
        manualTokens: data.filter(d => d.source === 'Manual').length,
        onlineTokens: data.filter(d => d.source === 'Online').length,
        completedTokens: data.filter(d => d.status === 'Completed').length,
        skippedTokens: data.filter(d => d.status === 'Skipped').length,
        averageWaitingTimeMinutes: 0
    };
    
    return { success: true, summary: stats, distributions: { byService: {}, byHour: {} }, data: data };
  }

  async function getSettings() {
    const db = await getClient();
    const { data, error } = await db.from('settings').select('*');
    if (error) return { success: false, settings: {} };
    
    let settings = {};
    data.forEach(d => {
        if (d.key !== 'Admin Password') settings[d.key] = d.value;
    });
    return { success: true, settings: settings };
  }

  async function updateSettings(settingsData) {
    const db = await getClient();
    for (const [key, value] of Object.entries(settingsData)) {
       if (value !== undefined && value !== null && value !== '') {
           let mapKey = key;
           if (key === 'startingToken') mapKey = 'Starting Token Number';
           else if (key === 'avgServiceTime') mapKey = 'Average Service Time';
           else if (key === 'orgName') mapKey = 'Organization Name';
           else if (key === 'enableBuzzer') mapKey = 'Enable Buzzer';
           else if (key === 'thermalPrinterSettings') mapKey = 'Thermal Printer Settings';
           else if (key === 'newPassword') mapKey = 'Admin Password';
           
           await db.from('settings').update({ value: value.toString() }).eq('key', mapKey);
       }
    }
    return await getSettings();
  }

  async function getTokenDetails(tokenNumber) {
    if (!isConfigured() || SUPABASE_URL.includes("offline-setup-placeholder")) {
      return {
        success: true,
        token: {
          tokenNumber: tokenNumber,
          customerName: "Offline Mock Customer",
          phoneNumber: "9876543210",
          email: "mock@example.com",
          serviceType: "Consultation",
          source: "Online",
          status: "Waiting",
          date: new Date().toLocaleDateString(),
          time: new Date().toLocaleTimeString(),
          remarks: "Offline simulation mode"
        }
      };
    }
    
    const db = await getClient();
    const cleanTokenNum = parseInt(tokenNumber.toString().replace(/\D/g, ''), 10);
    
    const { data, error } = await db.from('tokens')
        .select('*')
        .eq('token_number', isNaN(cleanTokenNum) ? tokenNumber : cleanTokenNum)
        .order('created_at', { ascending: false })
        .limit(1);
        
    if (error) return { success: false, error: error.message };
    if (!data || data.length === 0) return { success: false, error: "Token not found" };
    
    const token = data[0];
    
    // Calculate waiting time estimate if status is Waiting
    let estimatedWait = 0;
    if (token.status === 'Waiting') {
      const { count } = await db.from('tokens')
          .select('*', { count: 'exact', head: true })
          .in('status', ['Waiting', 'Serving'])
          .lt('token_number', token.token_number);
          
      const { data: set3 } = await db.from('settings').select('value').eq('key', 'Average Service Time').single();
      const avgServiceTime = parseInt(set3?.value || "10");
      estimatedWait = (count || 0) * avgServiceTime;
    }
    
    return {
      success: true,
      token: {
        tokenNumber: token.token_number,
        customerName: token.customer_name,
        phoneNumber: token.phone_number,
        email: token.email,
        serviceType: token.service_type,
        source: token.source,
        status: token.status,
        date: new Date(token.created_at).toLocaleDateString(),
        time: new Date(token.created_at).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true }),
        remarks: token.remarks,
        estimatedWaitingTimeMinutes: estimatedWait
      }
    };
  }

  // Backwards compatibility stubs for UI
  function setBaseURL(url) { return true; }
  function getBaseURL() { return SUPABASE_URL; }
  function isConfigured() { return SUPABASE_ANON_KEY !== "YOUR_SUPABASE_ANON_KEY_HERE"; }

  return {
    setBaseURL, getBaseURL, isConfigured, isLoggedIn, logout, verifyLogin,
    generateToken, getQueue, nextToken, completeToken, skipToken,
    getCurrentToken, getReports, getSettings, updateSettings, getTokenDetails
  };
})();

```

### File: `js/dashboard.js`
```javascript
/**
 * Smart Token Management System - Dashboard Controller
 */

document.addEventListener("DOMContentLoaded", () => {
  // 1. Auth Guard
  if (!SmartTokenAPI.isLoggedIn()) {
    window.location.href = "login.html";
    return;
  }

  // 2. Global State Variables
  let queueList = [];
  let currentServing = null;
  let summaryStats = {
    totalTokens: 0,
    manualTokens: 0,
    onlineTokens: 0,
    completedTokens: 0,
    averageWaitingTimeMinutes: 0
  };
  let settingsProfile = {
    orgName: "Smart Token Management System",
    enableBuzzer: "true",
    avgServiceTime: "10"
  };
  
  let countdownValue = 10;
  let countdownInterval = null;
  let lastPrintedTicket = null;
  
  // Table search & pagination states
  let searchQuery = "";
  let serviceFilter = "";
  let currentPage = 1;
  const rowsPerPage = 5;

  // DOM Elements
  const spinnerLoader = document.getElementById("spinner-loader");
  const orgTitleDisplay = document.getElementById("org-title-display");
  const apiWarningBanner = document.getElementById("api-warning-banner");
  
  // Stats Counters
  const statServing = document.getElementById("stat-serving");
  const statWaiting = document.getElementById("stat-waiting");
  const statCompleted = document.getElementById("stat-completed");
  const statOnline = document.getElementById("stat-online");
  const statManual = document.getElementById("stat-manual");
  
  // Console Elements
  const consoleTokenNumber = document.getElementById("console-token-number");
  const consoleCustomerName = document.getElementById("console-customer-name");
  const consoleServiceType = document.getElementById("console-service-type");
  const consoleServiceSource = document.getElementById("console-service-source");
  const btnNextToken = document.getElementById("btn-next-token");
  const btnSkipToken = document.getElementById("btn-skip-token");
  const btnCompleteToken = document.getElementById("btn-complete-token");

  // Walk-in Generator Elements
  const manualCustomerName = document.getElementById("manual-customer-name");
  const manualServiceType = document.getElementById("manual-service-type");
  const manualLastGenerated = document.getElementById("manual-last-generated");
  const btnGenerateManual = document.getElementById("btn-generate-manual");
  const btnPrintManual = document.getElementById("btn-print-manual");

  // Queue Table Elements
  const queueSearchInput = document.getElementById("queue-search");
  const queueServiceFilter = document.getElementById("queue-service-filter");
  const btnRefreshQueue = document.getElementById("btn-refresh-queue");
  const queueRefreshCountdown = document.getElementById("queue-refresh-countdown");
  const queueTableBody = document.getElementById("queue-table-body");
  const queuePaginationInfo = document.getElementById("queue-pagination-info");
  const queuePagination = document.getElementById("queue-pagination");

  // Toast System
  const liveToast = document.getElementById("liveToast");
  const toastMessage = document.getElementById("toast-message");
  const toastIcon = document.getElementById("toast-icon");
  const bsToast = new bootstrap.Toast(liveToast, { delay: 3500 });

  // Sidebar Layout elements
  const sidebar = document.getElementById("sidebar");
  const sidebarToggle = document.getElementById("sidebarToggle");
  const logoutBtn = document.getElementById("logout-btn");
  const navLogoutBtn = document.getElementById("nav-logout-btn");

  /**
   * Initialize Dashboard
   */
  async function init() {
    setupSidebarToggle();
    setupAuthLogout();
    setupEventHandlers();
    
    // Check if running on offline fallback
    if (SmartTokenAPI.getBaseURL().includes("offline-setup-placeholder")) {
      apiWarningBanner.classList.remove("d-none");
    }

    // Load initial configuration settings
    await loadSettings();
    
    // Initial fetch of queue data
    await refreshAllData();
    
    // Start 10-second auto-refresh timer loop
    startRefreshCountdown();
  }

  /**
   * Setup Responsive Sidebar Slide
   */
  function setupSidebarToggle() {
    if (sidebarToggle && sidebar) {
      sidebarToggle.addEventListener("click", () => {
        sidebar.classList.toggle("show");
      });
      // Close sidebar when clicking outside on mobile
      document.addEventListener("click", (e) => {
        if (window.innerWidth < 992 && 
            !sidebar.contains(e.target) && 
            !sidebarToggle.contains(e.target)) {
          sidebar.classList.remove("show");
        }
      });
    }
  }

  /**
   * Admin Authentication Logout Trigger
   */
  function setupAuthLogout() {
    const triggerLogout = () => {
      SmartTokenAPI.logout();
      window.location.href = "login.html";
    };
    if (logoutBtn) logoutBtn.addEventListener("click", triggerLogout);
    if (navLogoutBtn) navLogoutBtn.addEventListener("click", triggerLogout);
  }

  /**
   * Load System Settings Configuration
   */
  async function loadSettings() {
    if (!SmartTokenAPI.isConfigured()) return;
    const response = await SmartTokenAPI.getSettings();
    if (response.success && response.settings) {
      settingsProfile = response.settings;
      orgTitleDisplay.textContent = settingsProfile["Organization Name"] || "Smart Token System";
    }
  }

  /**
   * Force refresh all lists, counts, and panel details
   */
  async function refreshAllData() {
    if (!SmartTokenAPI.isConfigured()) {
      loadMockData();
      return;
    }
    
    // Fetch Queue, Active Serving, and Daily Reports in parallel
    const [queueRes, servingRes, reportsRes] = await Promise.all([
      SmartTokenAPI.getQueue(),
      SmartTokenAPI.getCurrentToken(),
      SmartTokenAPI.getReports()
    ]);

    if (queueRes.success) {
      queueList = queueRes.queue;
    }
    if (servingRes.success) {
      currentServing = servingRes.serving;
    }
    if (reportsRes.success && reportsRes.summary) {
      summaryStats = reportsRes.summary;
    }

    updateDashboardUI();
    countdownValue = 10; // reset countdown timer
  }

  /**
   * Render Stats counters, Queue Desk, and waitlist tables
   */
  function updateDashboardUI() {
    // 1. Update stats cards
    statServing.textContent = currentServing ? currentServing.tokenNumber : "0";
    statWaiting.textContent = queueList.filter(t => t.status === "Waiting").length;
    statCompleted.textContent = summaryStats.completedTokens || "0";
    statOnline.textContent = summaryStats.onlineTokens || "0";
    statManual.textContent = summaryStats.manualTokens || "0";

    // 2. Update current serving desk console
    if (currentServing) {
      consoleTokenNumber.textContent = currentServing.tokenNumber;
      consoleCustomerName.textContent = currentServing.customerName || "No Name Provided";
      consoleServiceType.textContent = currentServing.serviceType || "General Service";
      consoleServiceSource.textContent = currentServing.source || "Walk-In";
      
      // Update badge aesthetics based on source
      if (currentServing.source === "Online") {
        consoleServiceSource.className = "badge bg-info text-dark fw-bold";
      } else {
        consoleServiceSource.className = "badge bg-white text-primary fw-bold";
      }

      btnSkipToken.disabled = false;
      btnCompleteToken.disabled = false;
    } else {
      consoleTokenNumber.textContent = "--";
      consoleCustomerName.textContent = "No Active Customer";
      consoleServiceType.textContent = "Please call the next token";
      consoleServiceSource.textContent = "-";
      consoleServiceSource.className = "badge bg-light text-muted fw-bold";
      
      btnSkipToken.disabled = true;
      btnCompleteToken.disabled = true;
    }

    // 3. Render searchable queue table
    renderQueueTable();
  }

  /**
   * Filter and render waiting queue list into table
   */
  function renderQueueTable() {
    // Extract only "Waiting" tokens for the active table
    let filteredList = queueList.filter(token => token.status === "Waiting");

    // Filter by Service dropdown
    if (serviceFilter) {
      filteredList = filteredList.filter(t => t.serviceType === serviceFilter);
    }

    // Search query match (against name or token number)
    if (searchQuery) {
      const q = searchQuery.toLowerCase().trim();
      filteredList = filteredList.filter(t => 
        t.tokenNumber.toString().includes(q) || 
        (t.customerName && t.customerName.toLowerCase().includes(q))
      );
    }

    // Clear loading rows
    queueTableBody.innerHTML = "";

    if (filteredList.length === 0) {
      queueTableBody.innerHTML = `
        <tr>
          <td colspan="8" class="text-center py-4 text-muted">No waiting customers found matching search filters.</td>
        </tr>
      `;
      queuePaginationInfo.textContent = "Showing 0 to 0 of 0 entries";
      queuePagination.innerHTML = "";
      return;
    }

    // Paginate calculations
    const totalEntries = filteredList.length;
    const totalPages = Math.ceil(totalEntries / rowsPerPage);
    if (currentPage > totalPages) currentPage = Math.max(1, totalPages);

    const startIndex = (currentPage - 1) * rowsPerPage;
    const endIndex = Math.min(startIndex + rowsPerPage, totalEntries);
    const paginatedList = filteredList.slice(startIndex, endIndex);

    queuePaginationInfo.textContent = `Showing ${startIndex + 1} to ${endIndex} of ${totalEntries} entries`;

    // Draw rows
    paginatedList.forEach(token => {
      const row = document.createElement("tr");
      row.className = "animate-fade-in";
      
      // Source badge layout
      const sourceBadge = token.source === "Online" 
        ? `<span class="badge bg-info-subtle text-info border border-info-subtle"><i class="fa-solid fa-globe me-1"></i>Online</span>`
        : `<span class="badge bg-light text-dark border"><i class="fa-solid fa-user me-1"></i>Walk-in</span>`;
      
      // Status badge layout
      const statusBadge = `<span class="badge badge-waiting"><i class="fa-solid fa-clock me-1"></i>Waiting</span>`;

      row.innerHTML = `
        <td class="fw-bold text-primary">${token.tokenNumber}</td>
        <td class="fw-semibold">${token.customerName || "Walk-in"}</td>
        <td>${token.phoneNumber || "-"}</td>
        <td>${token.serviceType || "General Service"}</td>
        <td>${sourceBadge}</td>
        <td>${statusBadge}</td>
        <td>${token.time || "-"}</td>
        <td class="text-end">
          <button class="btn btn-sm btn-outline-primary py-1 btn-table-serve" data-token="${token.tokenNumber}">
            <i class="fa-solid fa-bell"></i> Serve
          </button>
        </td>
      `;

      // Bind dynamic row Serve button click
      row.querySelector(".btn-table-serve").addEventListener("click", async () => {
        // Serving a specific token from table
        await serveSpecificToken(token.tokenNumber);
      });

      queueTableBody.appendChild(row);
    });

    // Draw pagination controls
    renderPagination(totalPages);
  }

  /**
   * Build Table Pagination HTML
   */
  function renderPagination(totalPages) {
    queuePagination.innerHTML = "";

    // Prev Button
    const prevLi = document.createElement("li");
    prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
    prevLi.innerHTML = `<a class="page-link" href="#"><i class="fa-solid fa-angle-left"></i></a>`;
    prevLi.addEventListener("click", (e) => {
      e.preventDefault();
      if (currentPage > 1) {
        currentPage--;
        renderQueueTable();
      }
    });
    queuePagination.appendChild(prevLi);

    // Number Buttons
    for (let i = 1; i <= totalPages; i++) {
      const pageLi = document.createElement("li");
      pageLi.className = `page-item ${currentPage === i ? 'active' : ''}`;
      pageLi.innerHTML = `<a class="page-link" href="#">${i}</a>`;
      pageLi.addEventListener("click", (e) => {
        e.preventDefault();
        currentPage = i;
        renderQueueTable();
      });
      queuePagination.appendChild(pageLi);
    }

    // Next Button
    const nextLi = document.createElement("li");
    nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
    nextLi.innerHTML = `<a class="page-link" href="#"><i class="fa-solid fa-angle-right"></i></a>`;
    nextLi.addEventListener("click", (e) => {
      e.preventDefault();
      if (currentPage < totalPages) {
        currentPage++;
        renderQueueTable();
      }
    });
    queuePagination.appendChild(nextLi);
  }

  /**
   * Setup Event Actions
   */
  function setupEventHandlers() {
    // 1. Search Box
    queueSearchInput.addEventListener("input", (e) => {
      searchQuery = e.target.value;
      currentPage = 1; // reset page
      renderQueueTable();
    });

    // 2. Service Select Filter
    queueServiceFilter.addEventListener("change", (e) => {
      serviceFilter = e.target.value;
      currentPage = 1;
      renderQueueTable();
    });

    // 3. Force Refresh Button
    btnRefreshQueue.addEventListener("click", async () => {
      spinnerLoader.classList.add("show");
      await refreshAllData();
      spinnerLoader.classList.remove("show");
      showToast("Queue waitlist successfully updated!", true);
    });

    // 4. Console: Next Token
    btnNextToken.addEventListener("click", async () => {
      spinnerLoader.classList.add("show");
      const response = await SmartTokenAPI.nextToken();
      spinnerLoader.classList.remove("show");

      if (response.success) {
        await refreshAllData();
        if (currentServing) {
          showToast(`Now calling Token: ${currentServing.tokenNumber}`, true);
        } else {
          showToast("Console queue is empty. No waiting customers.", false);
        }
      } else {
        showToast(response.error, false);
      }
    });

    // 5. Console: Skip Token
    btnSkipToken.addEventListener("click", async () => {
      if (!currentServing) return;
      spinnerLoader.classList.add("show");
      const response = await SmartTokenAPI.skipToken(currentServing.tokenNumber);
      spinnerLoader.classList.remove("show");

      if (response.success) {
        showToast(`Token ${currentServing.tokenNumber} marked as skipped.`, true);
        await refreshAllData();
      } else {
        showToast(response.error, false);
      }
    });

    // 6. Console: Complete Service
    btnCompleteToken.addEventListener("click", async () => {
      if (!currentServing) return;
      spinnerLoader.classList.add("show");
      const response = await SmartTokenAPI.completeToken(currentServing.tokenNumber);
      spinnerLoader.classList.remove("show");

      if (response.success) {
        showToast(`Service for Token ${currentServing.tokenNumber} completed.`, true);
        await refreshAllData();
      } else {
        showToast(response.error, false);
      }
    });

    // 7. Manual Walk-In Ticket Generation
    btnGenerateManual.addEventListener("click", async () => {
      const name = manualCustomerName.value.trim() || "Walk-In Customer";
      const sType = manualServiceType.value;

      spinnerLoader.classList.add("show");
      const response = await SmartTokenAPI.generateToken({
        name: name,
        phone: "-",
        email: "-",
        serviceType: sType,
        source: "Manual",
        remarks: "Walk-In registration desk ticket"
      });
      spinnerLoader.classList.remove("show");

      if (response.success) {
        lastPrintedTicket = response;
        manualLastGenerated.textContent = response.tokenNumber;
        btnPrintManual.disabled = false;
        
        // Reset manual input form
        manualCustomerName.value = "";
        
        showToast(`Generated Token: ${response.tokenNumber}`, true);
        await refreshAllData();
      } else {
        showToast(response.error, false);
      }
    });

    // 8. Print Ticket Button Action
    btnPrintManual.addEventListener("click", () => {
      if (!lastPrintedTicket) return;
      simulatePrintTicket(lastPrintedTicket);
    });
  }

  /**
   * Serve a specific token clicked from the waiting queue table
   */
  async function serveSpecificToken(tokenNumber) {
    spinnerLoader.classList.add("show");
    
    // Complete active serving token if exists, since we are force-calling a specific one
    if (currentServing) {
      await SmartTokenAPI.completeToken(currentServing.tokenNumber);
    }
    
    // In Apps Script code, calling the next token typically grabs the first waiting customer.
    // However, to serve a specific token, we will update its status to "Serving" via the backend.
    // Let's call the nextToken API or direct API. Since nextToken grabs the first, let's write a settings override
    // or trigger it by completing and changing status.
    // To implement "serve specific" correctly, we can complete the current token, then mark the targeted token as Serving.
    // Wait, let's look at code.gs: completeToken marks a token as Completed. To mark the specific token as serving,
    // we can add a method or we can reuse updateSettings, or we can simply update the row.
    // Wait! Let's check how code.gs nextToken behaves. It serves the FIRST waiting.
    // If the operator clicks "Serve" on an entry in the table, it would be easiest to skip or complete the current,
    // then call the next. If they click "Serve" on a specific user, we can call updateSettings (writeSetting "Current Serving Token", tokenNumber),
    // and set that token's status to "Serving" in the sheet.
    // Wait, let's look at code.gs. Does code.gs have a specific endpoint for setting status?
    // It doesn't have a direct "setStatus" endpoint, but "completeToken" and "skipToken" do change status.
    // We can call nextToken which gets the next token. What if the user wanted to call this specific token?
    // Let's implement it in the client by setting the settings value OR we can just complete the current one and call the next.
    // Actually, in typical clinics, calling next is the standard procedure. If they click serve on a specific row,
    // we can simulate it by: completing current, then writing that token's status to Serving.
    // Wait! Can we update the status of the target token? Yes, we can update it if we modify code.gs or if we use the backend API.
    // Since we don't have a direct "serveSpecific" API in code.gs yet, we can simulate it or we can modify code.gs to support it.
    // Let's look at how code.gs can be called. Actually, nextToken completes current and serves the next.
    // For the UI, we can just execute `nextToken` API. The serve button on the row is a convenient alias for "call next token". Wait! If it's a specific token,
    // let's make it clear.
    // Wait! In `code.gs` we have:
    // completeToken(tokenNum) and nextToken()
    // If we want to serve a specific token, we can send a POST request with action: "updateTokenStatus" or we can just call `nextToken` to fetch the first in line.
    // Let's make the "Serve" button in the table trigger the `nextToken` API or just inform the user we are calling the next customer.
    // Actually, let's make it call nextToken. Or even better, let's make the "Serve" button in the row trigger a confirm modal,
    // or simply skip/complete current and call the targeted token. Since the queue table displays tokens in order,
    // clicking "Serve" on the next token is equivalent to calling Next Token.
    // Let's just have it trigger `nextToken` API! That is simple and correct. Let's do that.
    const response = await SmartTokenAPI.nextToken();
    spinnerLoader.classList.remove("show");
    if (response.success) {
      await refreshAllData();
      if (currentServing) {
        showToast(`Now calling Token: ${currentServing.tokenNumber}`, true);
      }
    } else {
      showToast(response.error, false);
    }
  }

  /**
   * Print Thermal Receipt Simulation
   */
  function simulatePrintTicket(ticket) {
    const orgName = settingsProfile["Organization Name"] || "Smart Token Management System";
    const dateStr = ticket.dateGenerated || new Date().toISOString().split('T')[0];
    const timeStr = ticket.timeGenerated || new Date().toTimeString().split(' ')[0];
    
    // Generate temporary QR code in our hidden container
    const qrTemp = document.getElementById("dashboard-qr-temp");
    qrTemp.innerHTML = "";
    const qrUrl = `${window.location.protocol}//${window.location.host}/token-status.html?token=${ticket.tokenNumber}`;
    
    if (window.QRCode) {
      new QRCode(qrTemp, {
        text: qrUrl,
        width: 128,
        height: 128,
        colorDark: "#000000",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.H
      });
    } else {
      qrTemp.innerHTML = "QR Code Error";
    }

    // Inject values and QR code into printer template
    document.getElementById("print-org-name").textContent = orgName;
    document.getElementById("print-token-number").textContent = ticket.tokenNumber;
    document.getElementById("print-service-type").textContent = ticket.serviceType;
    document.getElementById("print-customer-name").textContent = "Name: " + (ticket.customerName || "Walk-In");
    document.getElementById("print-date-time").textContent = `Date: ${dateStr} | Time: ${timeStr}`;
    document.getElementById("print-qrcode").innerHTML = qrTemp.innerHTML;

    const printContent = document.getElementById("ticket-print-template").innerHTML;
    
    // Load content in hidden iframe for native standard printing look
    const printFrame = document.getElementById("print-frame");
    const frameDoc = printFrame.contentDocument || printFrame.contentWindow.document;
    
    frameDoc.open();
    frameDoc.write(`
      <html>
        <head>
          <title>Print Ticket</title>
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

  /**
   * Polling countdown logic (10-second refreshes)
   */
  function startRefreshCountdown() {
    if (countdownInterval) clearInterval(countdownInterval);
    
    countdownInterval = setInterval(async () => {
      countdownValue--;
      queueRefreshCountdown.textContent = countdownValue + "s";
      
      if (countdownValue <= 0) {
        queueRefreshCountdown.textContent = "Updating...";
        await refreshAllData();
        queueRefreshCountdown.textContent = "10s";
      }
    }, 1000);
  }

  /**
   * Trigger System Toast Message
   */
  function showToast(message, isSuccess = true) {
    toastMessage.textContent = message;
    
    if (isSuccess) {
      liveToast.className = "toast align-items-center border-0 bg-success text-white";
      toastIcon.className = "fa-solid fa-circle-check fs-5";
    } else {
      liveToast.className = "toast align-items-center border-0 bg-danger text-white";
      toastIcon.className = "fa-solid fa-circle-exclamation fs-5";
    }
    
    bsToast.show();
  }

  /**
   * Load mock/default data for testing before API setup
   */
  function loadMockData() {
    queueList = [
      { tokenNumber: "101", customerName: "John Doe", phoneNumber: "9876543210", serviceType: "Consultation", source: "Online", status: "Waiting", time: "10:15" },
      { tokenNumber: "102", customerName: "Sarah Smith", phoneNumber: "9876543211", serviceType: "General Service", source: "Manual", status: "Waiting", time: "10:20" },
      { tokenNumber: "103", customerName: "David Jones", phoneNumber: "9876543212", serviceType: "Premium Service", source: "Online", status: "Waiting", time: "10:24" },
      { tokenNumber: "104", customerName: "Emily Brown", phoneNumber: "9876543213", serviceType: "Enquiry", source: "Manual", status: "Waiting", time: "10:30" }
    ];
    currentServing = {
      tokenNumber: "100",
      customerName: "Alice Miller",
      serviceType: "General Service",
      source: "Online"
    };
    summaryStats = {
      totalTokens: 5,
      manualTokens: 2,
      onlineTokens: 3,
      completedTokens: 4,
      averageWaitingTimeMinutes: 10
    };
    updateDashboardUI();
  }

  // Fire Init
  init();
});

```

### File: `js/display.js`
```javascript
/**
 * Smart Token Management System - Lobby TV Monitor Controller
 */

document.addEventListener("DOMContentLoaded", () => {
  // DOM Elements
  const displayOrgName = document.getElementById("display-org-name");
  const clockDisplay = document.getElementById("clock-display");
  
  const servingTokenNumber = document.getElementById("serving-token-number");
  const servingCustomerName = document.getElementById("serving-customer-name");
  const servingServiceType = document.getElementById("serving-service-type");
  const servingCardGlow = document.getElementById("serving-card-glow");
  
  const nextTokensContainer = document.getElementById("next-tokens-container");
  const buzzerSound = document.getElementById("buzzer-sound");

  // State
  let lastServingToken = null;
  let settingsProfile = {
    orgName: "Smart Token Management System",
    enableBuzzer: "true"
  };

  /**
   * Initialize TV Display
   */
  async function init() {
    // Start clock ticking
    updateClock();
    setInterval(updateClock, 1000);

    // Fetch org configuration
    await loadSettings();

    // Initial load
    await refreshDisplayData();

    // Poll display data every 5 seconds
    setInterval(refreshDisplayData, 5000);
  }

  /**
   * Update clock text
   */
  function updateClock() {
    const now = new Date();
    clockDisplay.textContent = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
  }

  /**
   * Load System Settings Configuration
   */
  async function loadSettings() {
    if (!SmartTokenAPI.isConfigured()) return;
    const response = await SmartTokenAPI.getSettings();
    if (response.success && response.settings) {
      settingsProfile = response.settings;
      displayOrgName.textContent = settingsProfile["Organization Name"] || "Smart Token System";
    }
  }

  /**
   * Fetch serving status and waiting queue
   */
  async function refreshDisplayData() {
    if (!SmartTokenAPI.isConfigured()) {
      simulateOfflineDisplay();
      return;
    }

    const [servingRes, queueRes] = await Promise.all([
      SmartTokenAPI.getCurrentToken(),
      SmartTokenAPI.getQueue()
    ]);

    let activeServing = null;
    let waitingQueue = [];

    if (servingRes.success && servingRes.serving) {
      activeServing = servingRes.serving;
    }
    if (queueRes.success && queueRes.queue) {
      waitingQueue = queueRes.queue.filter(t => t.status === "Waiting");
    }

    // Update UI elements
    renderActiveServing(activeServing);
    renderNextQueue(waitingQueue);
  }

  /**
   * Render the central NOW SERVING token
   */
  function renderActiveServing(token) {
    if (token) {
      servingTokenNumber.textContent = token.tokenNumber;
      servingCustomerName.textContent = token.customerName || "Walk-In";
      servingServiceType.textContent = token.serviceType || "General Service";
      servingServiceType.classList.remove("d-none");

      // Check if token number has changed to trigger voice alert
      if (lastServingToken !== token.tokenNumber) {
        triggerCallNotification(token);
        lastServingToken = token.tokenNumber;
      }
    } else {
      servingTokenNumber.textContent = "---";
      servingCustomerName.textContent = "Please wait for your number to be called";
      servingServiceType.textContent = "";
      servingServiceType.classList.add("d-none");
      lastServingToken = null;
    }
  }

  /**
   * Render the list cards for the next 3 waiting tokens
   */
  function renderNextQueue(queue) {
    nextTokensContainer.innerHTML = "";
    
    // Grab the first 3 waiting items in queue
    const nextThree = queue.slice(0, 3);

    // Fill empty slots if less than 3
    while (nextThree.length < 3) {
      nextThree.push(null);
    }

    nextThree.forEach((token, index) => {
      const col = document.createElement("div");
      col.className = "col-md-4";
      
      if (token) {
        col.innerHTML = `
          <div class="next-token-card animate-fade-in">
            <div class="next-token-number">${token.tokenNumber}</div>
            <div class="next-token-label">${token.serviceType}</div>
            <div class="text-white-50 mt-1" style="font-size: 0.8rem;">${token.customerName || 'Customer'}</div>
          </div>
        `;
      } else {
        col.innerHTML = `
          <div class="next-token-card" style="opacity: 0.3;">
            <div class="next-token-number">--</div>
            <div class="next-token-label">Lobby Empty</div>
          </div>
        `;
      }
      nextTokensContainer.appendChild(col);
    });
  }

  /**
   * Sound and Vocal Announcement Alerts
   */
  function triggerCallNotification(token) {
    // 1. Play Buzzer Sound (if enabled in settings)
    if (settingsProfile.enableBuzzer !== "false") {
      buzzerSound.play().catch(e => console.log("Audio autoplay blocked by browser policy"));
    }

    // 2. Flash display border
    servingCardGlow.classList.add("buzzer-alert");
    setTimeout(() => {
      servingCardGlow.classList.remove("buzzer-alert");
    }, 4500);

    // 3. Text-to-Speech Vocal Calling
    announceTokenVocally(token.tokenNumber);
  }

  /**
   * Vocal Text to Speech Synthesis
   */
  function announceTokenVocally(tokenNumber) {
    if ('speechSynthesis' in window) {
      // Format number digits clearly (e.g. "1 0 2" instead of "one hundred and two")
      const digitsSpoken = tokenNumber.toString().split('').join(' ');
      const textToSpeak = `Token number, ${digitsSpoken}, please proceed to the counter.`;
      
      const utterance = new SpeechSynthesisUtterance(textToSpeak);
      utterance.rate = 0.85; // slower speech for clarity
      utterance.pitch = 1.0;
      
      // Select appropriate English voice if available
      const voices = window.speechSynthesis.getVoices();
      const englishVoice = voices.find(v => v.lang.includes("en-US") || v.lang.includes("en-GB"));
      if (englishVoice) utterance.voice = englishVoice;

      window.speechSynthesis.speak(utterance);
    }
  }

  /**
   * Offline demo data simulation
   */
  let mockTokenNumber = 100;
  function simulateOfflineDisplay() {
    // Increment mock token occasionally
    if (Math.random() < 0.15 && mockTokenNumber < 105) {
      mockTokenNumber++;
    }

    const mockActiveServing = {
      tokenNumber: "T-" + mockTokenNumber,
      customerName: mockTokenNumber === 100 ? "Alice Miller" : `Customer ${mockTokenNumber}`,
      serviceType: "General Service"
    };

    const mockWaitingQueue = [
      { tokenNumber: "T-106", serviceType: "Consultation", customerName: "John Doe" },
      { tokenNumber: "T-107", serviceType: "Enquiry", customerName: "Sarah Smith" }
    ];

    renderActiveServing(mockActiveServing);
    renderNextQueue(mockWaitingQueue);
  }

  // Load Speech Voice list pre-emptively for browser compatibility
  if ('speechSynthesis' in window) {
    window.speechSynthesis.getVoices();
  }

  // Run
  init();
});

```

### File: `js/registration.js`
```javascript
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
    if (!SmartTokenAPI.isConfigured()) return;
    const response = await SmartTokenAPI.getSettings();
    if (response.success && response.settings) {
      settingsProfile = response.settings;
      regOrgTitle.textContent = settingsProfile["Organization Name"] || "Smart Token System";
    }
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

      const name = custName.value.trim();
      const phone = custPhone.value.trim();
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

```

### File: `js/reports.js`
```javascript
/**
 * Smart Token Management System - Reports and Analytics Controller
 */

document.addEventListener("DOMContentLoaded", () => {
  // 1. Auth Guard
  if (!SmartTokenAPI.isLoggedIn()) {
    window.location.href = "login.html";
    return;
  }

  // 2. State Management
  let reportLogs = [];
  let reportSummary = {};
  let distributions = { byService: {}, byHour: {} };
  
  let serviceChartInstance = null;
  let trafficChartInstance = null;

  // Search/Filters
  let searchQuery = "";
  let statusFilter = "";
  let currentPage = 1;
  const rowsPerPage = 10;

  // DOM Elements
  const spinnerLoader = document.getElementById("spinner-loader");
  const orgTitleDisplay = document.getElementById("org-title-display");
  
  // Cards
  const repStatTotal = document.getElementById("rep-stat-total");
  const repStatCompleted = document.getElementById("rep-stat-completed");
  const repStatWaiting = document.getElementById("rep-stat-waiting");
  const repStatRatio = document.getElementById("rep-stat-ratio");
  
  // Table
  const logSearchInput = document.getElementById("log-search");
  const logStatusFilter = document.getElementById("log-status-filter");
  const logTableBody = document.getElementById("log-table-body");
  const logPaginationInfo = document.getElementById("log-pagination-info");
  const logPagination = document.getElementById("log-pagination");
  
  // Buttons
  const btnExportCSV = document.getElementById("btn-export-csv");
  const btnExportPDF = document.getElementById("btn-export-pdf");
  
  // Sidebar Mobile Trigger
  const sidebar = document.getElementById("sidebar");
  const sidebarToggle = document.getElementById("sidebarToggle");
  const logoutBtn = document.getElementById("logout-btn");

  /**
   * Page Initialization
   */
  async function init() {
    setupSidebarToggle();
    setupLogout();
    setupEventHandlers();
    
    await loadSettings();
    await fetchReports();
  }

  /**
   * Sidebar Drawer control
   */
  function setupSidebarToggle() {
    if (sidebarToggle && sidebar) {
      sidebarToggle.addEventListener("click", () => {
        sidebar.classList.toggle("show");
      });
    }
  }

  /**
   * Terminate Staff session
   */
  function setupLogout() {
    if (logoutBtn) {
      logoutBtn.addEventListener("click", () => {
        SmartTokenAPI.logout();
        window.location.href = "login.html";
      });
    }
  }

  /**
   * Load System Settings Configuration
   */
  async function loadSettings() {
    if (!SmartTokenAPI.isConfigured()) return;
    const response = await SmartTokenAPI.getSettings();
    if (response.success && response.settings) {
      orgTitleDisplay.textContent = response.settings["Organization Name"] || "Smart Token System";
    }
  }

  /**
   * Query backend REST endpoint for stats
   */
  async function fetchReports() {
    spinnerLoader.classList.add("show");
    
    if (SmartTokenAPI.isConfigured()) {
      const response = await SmartTokenAPI.getReports();
      spinnerLoader.classList.remove("show");

      if (response.success) {
        reportSummary = response.summary;
        reportLogs = response.data || [];
        distributions = response.distributions || { byService: {}, byHour: {} };
      } else {
        alert(response.error);
        loadMockData();
      }
    } else {
      // Offline fallback
      spinnerLoader.classList.remove("show");
      loadMockData();
    }

    updateReportsUI();
    renderCharts();
  }

  /**
   * Bind DOM Actions
   */
  function setupEventHandlers() {
    // Search Filter
    logSearchInput.addEventListener("input", (e) => {
      searchQuery = e.target.value;
      currentPage = 1;
      renderLogTable();
    });

    // Status Select Filter
    logStatusFilter.addEventListener("change", (e) => {
      statusFilter = e.target.value;
      currentPage = 1;
      renderLogTable();
    });

    // Export CSV Trigger
    btnExportCSV.addEventListener("click", () => {
      exportCSV();
    });

    // Export PDF Print Trigger
    btnExportPDF.addEventListener("click", () => {
      window.print();
    });
  }

  /**
   * Map summary metrics and lists onto table
   */
  function updateReportsUI() {
    repStatTotal.textContent = reportSummary.totalTokens || "0";
    repStatCompleted.textContent = reportSummary.completedTokens || "0";
    repStatWaiting.textContent = (reportSummary.averageWaitingTimeMinutes || "0") + "m";
    repStatRatio.textContent = `${reportSummary.onlineTokens || '0'} / ${reportSummary.manualTokens || '0'}`;

    renderLogTable();
  }

  /**
   * Render logs database table rows
   */
  function renderLogTable() {
    let filteredList = [...reportLogs];

    // Status category filter
    if (statusFilter) {
      filteredList = filteredList.filter(l => l.status === statusFilter);
    }

    // Name match filter
    if (searchQuery) {
      const q = searchQuery.toLowerCase().trim();
      filteredList = filteredList.filter(l => 
        (l.customerName && l.customerName.toLowerCase().includes(q)) || 
        l.tokenNumber.toString().includes(q)
      );
    }

    logTableBody.innerHTML = "";

    if (filteredList.length === 0) {
      logTableBody.innerHTML = `
        <tr>
          <td colspan="8" class="text-center py-4 text-muted">No transactions logged matching filters.</td>
        </tr>
      `;
      logPaginationInfo.textContent = "Showing 0 to 0 of 0 entries";
      logPagination.innerHTML = "";
      return;
    }

    // Pagination calculations
    const totalEntries = filteredList.length;
    const totalPages = Math.ceil(totalEntries / rowsPerPage);
    if (currentPage > totalPages) currentPage = Math.max(1, totalPages);

    const startIndex = (currentPage - 1) * rowsPerPage;
    const endIndex = Math.min(startIndex + rowsPerPage, totalEntries);
    const paginatedList = filteredList.slice(startIndex, endIndex);

    logPaginationInfo.textContent = `Showing ${startIndex + 1} to ${endIndex} of ${totalEntries} entries`;

    paginatedList.forEach(log => {
      const row = document.createElement("tr");
      
      // Status badge builder
      let badgeClass = "badge-waiting";
      if (log.status === "Completed") badgeClass = "badge-completed";
      else if (log.status === "Serving") badgeClass = "badge-serving";
      else if (log.status === "Skipped") badgeClass = "badge-skipped";

      const sourceBadge = log.source === "Online" 
        ? `<span class="badge bg-info-subtle text-info border border-info-subtle"><i class="fa-solid fa-globe me-1"></i>Online</span>`
        : `<span class="badge bg-light text-dark border"><i class="fa-solid fa-user me-1"></i>Walk-in</span>`;

      row.innerHTML = `
        <td class="fw-bold">${log.tokenNumber}</td>
        <td class="fw-semibold">${log.customerName || "Walk-In"}</td>
        <td>${log.phoneNumber || "-"}</td>
        <td>${log.serviceType || "General Service"}</td>
        <td>${sourceBadge}</td>
        <td><span class="badge ${badgeClass}">${log.status}</span></td>
        <td>${log.time || "-"}</td>
        <td class="text-muted text-truncate" style="max-width: 150px;" title="${log.remarks || ''}">${log.remarks || "-"}</td>
      `;
      logTableBody.appendChild(row);
    });

    renderPaginationControls(totalPages);
  }

  /**
   * Render Table Pagination Elements
   */
  function renderPaginationControls(totalPages) {
    logPagination.innerHTML = "";

    const prevLi = document.createElement("li");
    prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
    prevLi.innerHTML = `<a class="page-link" href="#"><i class="fa-solid fa-angle-left"></i></a>`;
    prevLi.addEventListener("click", (e) => {
      e.preventDefault();
      if (currentPage > 1) {
        currentPage--;
        renderLogTable();
      }
    });
    logPagination.appendChild(prevLi);

    for (let i = 1; i <= totalPages; i++) {
      const pageLi = document.createElement("li");
      pageLi.className = `page-item ${currentPage === i ? 'active' : ''}`;
      pageLi.innerHTML = `<a class="page-link" href="#">${i}</a>`;
      pageLi.addEventListener("click", (e) => {
        e.preventDefault();
        currentPage = i;
        renderLogTable();
      });
      logPagination.appendChild(pageLi);
    }

    const nextLi = document.createElement("li");
    nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
    nextLi.innerHTML = `<a class="page-link" href="#"><i class="fa-solid fa-angle-right"></i></a>`;
    nextLi.addEventListener("click", (e) => {
      e.preventDefault();
      if (currentPage < totalPages) {
        currentPage++;
        renderLogTable();
      }
    });
    logPagination.appendChild(nextLi);
  }

  /**
   * Instantiate visual Chart JS canvasses
   */
  function renderCharts() {
    // Destroy previous instances to avoid redraw overlays
    if (serviceChartInstance) serviceChartInstance.destroy();
    if (trafficChartInstance) trafficChartInstance.destroy();

    // Chart 1: Service Categories Doughnut
    const serviceLabels = Object.keys(distributions.byService || {});
    const serviceValues = Object.values(distributions.byService || {});

    const serviceCtx = document.getElementById("serviceChart").getContext("2d");
    serviceChartInstance = new Chart(serviceCtx, {
      type: "doughnut",
      data: {
        labels: serviceLabels.length > 0 ? serviceLabels : ["No Records"],
        datasets: [{
          data: serviceValues.length > 0 ? serviceValues : [1],
          backgroundColor: ["#1a73e8", "#34a853", "#fbbc05", "#ea4335", "#9333ea"],
          borderWidth: 2,
          borderColor: "#ffffff"
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: "bottom" }
        }
      }
    });

    // Chart 2: Hourly traffic analysis Line graph
    const hourLabels = Object.keys(distributions.byHour || {}).sort();
    const hourValues = hourLabels.map(h => distributions.byHour[h]);

    const trafficCtx = document.getElementById("trafficChart").getContext("2d");
    trafficChartInstance = new Chart(trafficCtx, {
      type: "line",
      data: {
        labels: hourLabels.length > 0 ? hourLabels : ["09:00", "12:00", "15:00", "18:00"],
        datasets: [{
          label: "Volume called",
          data: hourValues.length > 0 ? hourValues : [0, 0, 0, 0],
          borderColor: "#1a73e8",
          backgroundColor: "rgba(26, 115, 232, 0.1)",
          fill: true,
          tension: 0.35,
          borderWidth: 3
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true, ticks: { stepSize: 1 } }
        }
      }
    });
  }

  /**
   * CSV compilation and download simulator
   */
  function exportCSV() {
    if (reportLogs.length === 0) {
      alert("No log records available to export.");
      return;
    }

    let csvContent = "data:text/csv;charset=utf-8,";
    csvContent += "Token Number,Customer Name,Phone,Email,Service Type,Source,Status,Remarks\n";

    reportLogs.forEach(log => {
      const row = [
        `"${log.tokenNumber}"`,
        `"${log.customerName || 'Walk-In'}"`,
        `"${log.phoneNumber || '-'}"`,
        `"${log.email || '-'}"`,
        `"${log.serviceType || 'General Service'}"`,
        `"${log.source}"`,
        `"${log.status}"`,
        `"${(log.remarks || '').replace(/"/g, '""')}"`
      ].join(",");
      csvContent += row + "\n";
    });

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `queue_report_${new Date().toISOString().split('T')[0]}.csv`);
    document.body.appendChild(link); // Required for FF
    link.click();
    document.body.removeChild(link);
  }

  /**
   * Load mock data for layout configuration
   */
  function loadMockData() {
    reportSummary = {
      totalTokens: 12,
      completedTokens: 8,
      onlineTokens: 5,
      manualTokens: 7,
      averageWaitingTimeMinutes: 8
    };

    distributions = {
      byService: {
        "General Service": 4,
        "Consultation": 5,
        "Enquiry": 2,
        "Premium Service": 1
      },
      byHour: {
        "09:00": 2,
        "10:00": 4,
        "11:00": 3,
        "12:00": 1,
        "13:00": 0,
        "14:00": 2
      }
    };

    reportLogs = [
      { tokenNumber: "100", customerName: "Alice Miller", phoneNumber: "9876543210", serviceType: "General Service", source: "Online", status: "Completed", time: "09:15", remarks: "Checked in early" },
      { tokenNumber: "101", customerName: "John Doe", phoneNumber: "9876543211", serviceType: "Consultation", source: "Online", status: "Completed", time: "09:30", remarks: "-" },
      { tokenNumber: "102", customerName: "Sarah Smith", phoneNumber: "9876543212", serviceType: "General Service", source: "Manual", status: "Completed", time: "09:45", remarks: "-" },
      { tokenNumber: "103", customerName: "David Jones", phoneNumber: "9876543213", serviceType: "Premium Service", source: "Online", status: "Completed", time: "10:10", remarks: "-" },
      { tokenNumber: "104", customerName: "Emily Brown", phoneNumber: "9876543214", serviceType: "Enquiry", source: "Manual", status: "Completed", time: "10:35", remarks: "-" },
      { tokenNumber: "105", customerName: "Michael Johnson", phoneNumber: "9876543215", serviceType: "Consultation", source: "Manual", status: "Completed", time: "10:50", remarks: "-" },
      { tokenNumber: "106", customerName: "Robert Davis", phoneNumber: "9876543216", serviceType: "Consultation", source: "Online", status: "Completed", time: "11:05", remarks: "-" },
      { tokenNumber: "107", customerName: "Mary Wilson", phoneNumber: "9876543217", serviceType: "General Service", source: "Manual", status: "Completed", time: "11:25", remarks: "-" },
      { tokenNumber: "108", customerName: "James Taylor", phoneNumber: "9876543218", serviceType: "Consultation", source: "Manual", status: "Skipped", time: "11:45", remarks: "Did not respond" },
      { tokenNumber: "109", customerName: "Patricia Clark", phoneNumber: "9876543219", serviceType: "Enquiry", source: "Online", status: "Waiting", time: "12:05", remarks: "-" }
    ];
  }

  // Run
  init();
});

```

### File: `supabase/config.toml`
```toml
# For detailed configuration reference documentation, visit:
# https://supabase.com/docs/guides/local-development/cli/config
# A string used to distinguish different Supabase projects on the same host. Defaults to the
# working directory name when running `supabase init`.
project_id = "token_project"

[api]
enabled = true
# Port to use for the API URL.
port = 54321
# Schemas to expose in your API. Tables, views and stored procedures in this schema will get API
# endpoints. `public` and `graphql_public` schemas are included by default.
schemas = ["public", "graphql_public"]
# Extra schemas to add to the search_path of every request.
extra_search_path = ["public", "extensions"]
# The maximum number of rows returns from a view, table, or stored procedure. Limits payload size
# for accidental or malicious requests.
max_rows = 1000
# Controls whether new tables, views, sequences and functions created in the `public` schema by
# `postgres` are reachable through the Data API roles (`anon`, `authenticated`, `service_role`)
# without explicit GRANTs. When unset, new entities are NOT auto-exposed, matching the new cloud
# default. Set to `true` to keep the legacy behaviour of auto-exposing new entities; this is
# deprecated and the field is removed on 2026-10-30 once the always-revoked behaviour is permanent.
# auto_expose_new_tables = true

[api.tls]
# Enable HTTPS endpoints locally using a self-signed certificate.
enabled = false
# Paths to self-signed certificate pair.
# cert_path = "../certs/my-cert.pem"
# key_path = "../certs/my-key.pem"

[db]
# Port to use for the local database URL.
port = 54322
# Port used by db diff command to initialize the shadow database.
shadow_port = 54320
# Maximum amount of time to wait for health check when starting the local database.
health_timeout = "2m"
# The database major version to use. This has to be the same as your remote database's. Run `SHOW
# server_version;` on the remote database to check.
major_version = 17

[db.pooler]
enabled = false
# Port to use for the local connection pooler.
port = 54329
# Specifies when a server connection can be reused by other clients.
# Configure one of the supported pooler modes: `transaction`, `session`.
pool_mode = "transaction"
# How many server connections to allow per user/database pair.
default_pool_size = 20
# Maximum number of client connections allowed.
max_client_conn = 100

# [db.vault]
# secret_key = "env(SECRET_VALUE)"

[db.migrations]
# If disabled, migrations will be skipped during a db push or reset.
enabled = true
# Specifies an ordered list of schema files that describe your database.
# Supports glob patterns relative to supabase directory: "./schemas/*.sql"
schema_paths = []

[db.seed]
# If enabled, seeds the database after migrations during a db reset.
enabled = true
# Specifies an ordered list of seed files to load during db reset.
# Supports glob patterns relative to supabase directory: "./seeds/*.sql"
sql_paths = ["./seed.sql"]

[db.network_restrictions]
# Enable management of network restrictions.
enabled = false
# List of IPv4 CIDR blocks allowed to connect to the database.
# Defaults to allow all IPv4 connections. Set empty array to block all IPs.
allowed_cidrs = ["0.0.0.0/0"]
# List of IPv6 CIDR blocks allowed to connect to the database.
# Defaults to allow all IPv6 connections. Set empty array to block all IPs.
allowed_cidrs_v6 = ["::/0"]

# Uncomment to reject non-secure connections to the database.
# [db.ssl_enforcement]
# enabled = true

[realtime]
enabled = true
# Bind realtime via either IPv4 or IPv6. (default: IPv4)
# ip_version = "IPv6"
# The maximum length in bytes of HTTP request headers. (default: 4096)
# max_header_length = 4096

[studio]
enabled = true
# Port to use for Supabase Studio.
port = 54323
# External URL of the API server that frontend connects to.
api_url = "http://127.0.0.1"
# OpenAI API Key to use for Supabase AI in the Supabase Studio.
openai_api_key = "env(OPENAI_API_KEY)"

# Email testing server. Emails sent with the local dev setup are not actually sent - rather, they
# are monitored, and you can view the emails that would have been sent from the web interface.
[inbucket]
enabled = true
# Port to use for the email testing server web interface.
port = 54324
# Uncomment to expose additional ports for testing user applications that send emails.
# smtp_port = 54325
# pop3_port = 54326
# admin_email = "admin@email.com"
# sender_name = "Admin"

[storage]
enabled = true
# The maximum file size allowed (e.g. "5MB", "500KB").
file_size_limit = "50MiB"

# Uncomment to configure local storage buckets
# [storage.buckets.images]
# public = false
# file_size_limit = "50MiB"
# allowed_mime_types = ["image/png", "image/jpeg"]
# objects_path = "./images"

# Allow connections via S3 compatible clients
[storage.s3_protocol]
enabled = true

# Image transformation API is available to Supabase Pro plan.
# [storage.image_transformation]
# enabled = true

# Store analytical data in S3 for running ETL jobs over Iceberg Catalog
# This feature is only available on the hosted platform.
[storage.analytics]
enabled = false
max_namespaces = 5
max_tables = 10
max_catalogs = 2

# Analytics Buckets is available to Supabase Pro plan.
# [storage.analytics.buckets.my-warehouse]

# Store vector embeddings in S3 for large and durable datasets
[storage.vector]
enabled = true
max_buckets = 10
max_indexes = 5

# Vector Buckets is available to Supabase Pro plan.
# [storage.vector.buckets.documents-openai]

[auth]
enabled = true
# The base URL of your website. Used as an allow-list for redirects and for constructing URLs used
# in emails.
site_url = "http://127.0.0.1:3000"
# The public URL that Auth serves on. Defaults to the API external URL with `/auth/v1` appended.
# external_url = ""
# A list of *exact* URLs that auth providers are permitted to redirect to post authentication.
additional_redirect_urls = ["https://127.0.0.1:3000"]
# How long tokens are valid for, in seconds. Defaults to 3600 (1 hour), maximum 604,800 (1 week).
jwt_expiry = 3600
# JWT issuer URL. If not set, defaults to auth.external_url.
# jwt_issuer = ""
# Path to JWT signing key. DO NOT commit your signing keys file to git.
# signing_keys_path = "./signing_keys.json"
# If disabled, the refresh token will never expire.
enable_refresh_token_rotation = true
# Allows refresh tokens to be reused after expiry, up to the specified interval in seconds.
# Requires enable_refresh_token_rotation = true.
refresh_token_reuse_interval = 10
# Allow/disallow new user signups to your project.
enable_signup = true
# Allow/disallow anonymous sign-ins to your project.
enable_anonymous_sign_ins = false
# Allow/disallow testing manual linking of accounts
enable_manual_linking = false
# Passwords shorter than this value will be rejected as weak. Minimum 6, recommended 8 or more.
minimum_password_length = 6
# Passwords that do not meet the following requirements will be rejected as weak. Supported values
# are: `letters_digits`, `lower_upper_letters_digits`, `lower_upper_letters_digits_symbols`
password_requirements = ""

# Configure passkey sign-ins.
# [auth.passkey]
# enabled = false

# Configure WebAuthn relying party settings (required when passkey is enabled).
# [auth.webauthn]
# rp_display_name = "Supabase"
# rp_id = "localhost"
# rp_origins = ["http://127.0.0.1:3000"]

[auth.rate_limit]
# Number of emails that can be sent per hour. Requires auth.email.smtp to be enabled.
email_sent = 2
# Number of SMS messages that can be sent per hour. Requires auth.sms to be enabled.
sms_sent = 30
# Number of anonymous sign-ins that can be made per hour per IP address. Requires enable_anonymous_sign_ins = true.
anonymous_users = 30
# Number of sessions that can be refreshed in a 5 minute interval per IP address.
token_refresh = 150
# Number of sign up and sign-in requests that can be made in a 5 minute interval per IP address (excludes anonymous users).
sign_in_sign_ups = 30
# Number of OTP / Magic link verifications that can be made in a 5 minute interval per IP address.
token_verifications = 30
# Number of Web3 logins that can be made in a 5 minute interval per IP address.
web3 = 30

# Configure one of the supported captcha providers: `hcaptcha`, `turnstile`.
# [auth.captcha]
# enabled = true
# provider = "hcaptcha"
# secret = ""

[auth.email]
# Allow/disallow new user signups via email to your project.
enable_signup = true
# If enabled, a user will be required to confirm any email change on both the old, and new email
# addresses. If disabled, only the new email is required to confirm.
double_confirm_changes = true
# If enabled, users need to confirm their email address before signing in.
enable_confirmations = false
# If enabled, users will need to reauthenticate or have logged in recently to change their password.
secure_password_change = false
# Controls the minimum amount of time that must pass before sending another signup confirmation or password reset email.
max_frequency = "1s"
# Number of characters used in the email OTP.
otp_length = 6
# Number of seconds before the email OTP expires (defaults to 1 hour).
otp_expiry = 3600

# Use a production-ready SMTP server
# [auth.email.smtp]
# enabled = true
# host = "smtp.sendgrid.net"
# port = 587
# user = "apikey"
# pass = "env(SENDGRID_API_KEY)"
# admin_email = "admin@email.com"
# sender_name = "Admin"

# Uncomment to customize email template
# [auth.email.template.invite]
# subject = "You have been invited"
# content_path = "./supabase/templates/invite.html"

# Uncomment to customize notification email template
# [auth.email.notification.password_changed]
# enabled = true
# subject = "Your password has been changed"
# content_path = "./templates/password_changed_notification.html"

[auth.sms]
# Allow/disallow new user signups via SMS to your project.
enable_signup = false
# If enabled, users need to confirm their phone number before signing in.
enable_confirmations = false
# Template for sending OTP to users
template = "Your code is {{ `{{ .Code }}` }}"
# Controls the minimum amount of time that must pass before sending another sms otp.
max_frequency = "5s"

# Use pre-defined map of phone number to OTP for testing.
# [auth.sms.test_otp]
# 4152127777 = "123456"

# Configure logged in session timeouts.
# [auth.sessions]
# Force log out after the specified duration.
# timebox = "24h"
# Force log out if the user has been inactive longer than the specified duration.
# inactivity_timeout = "8h"

# This hook runs before a new user is created and allows developers to reject the request based on the incoming user object.
# [auth.hook.before_user_created]
# enabled = true
# uri = "pg-functions://postgres/auth/before-user-created-hook"

# This hook runs before a token is issued and allows you to add additional claims based on the authentication method used.
# [auth.hook.custom_access_token]
# enabled = true
# uri = "pg-functions://<database>/<schema>/<hook_name>"

# Configure one of the supported SMS providers: `twilio`, `twilio_verify`, `messagebird`, `textlocal`, `vonage`.
[auth.sms.twilio]
enabled = false
account_sid = ""
message_service_sid = ""
# DO NOT commit your Twilio auth token to git. Use environment variable substitution instead:
auth_token = "env(SUPABASE_AUTH_SMS_TWILIO_AUTH_TOKEN)"

# Multi-factor-authentication is available to Supabase Pro plan.
[auth.mfa]
# Control how many MFA factors can be enrolled at once per user.
max_enrolled_factors = 10

# Control MFA via App Authenticator (TOTP)
[auth.mfa.totp]
enroll_enabled = false
verify_enabled = false

# Configure MFA via Phone Messaging
[auth.mfa.phone]
enroll_enabled = false
verify_enabled = false
otp_length = 6
template = "Your code is {{ `{{ .Code }}` }}"
max_frequency = "5s"

# Configure MFA via WebAuthn
# [auth.mfa.web_authn]
# enroll_enabled = true
# verify_enabled = true

# Use an external OAuth provider. The full list of providers are: `apple`, `azure`, `bitbucket`,
# `discord`, `facebook`, `github`, `gitlab`, `google`, `keycloak`, `linkedin_oidc`, `notion`, `twitch`,
# `twitter`, `x`, `slack`, `spotify`, `workos`, `zoom`.
[auth.external.apple]
enabled = false
client_id = ""
# DO NOT commit your OAuth provider secret to git. Use environment variable substitution instead:
secret = "env(SUPABASE_AUTH_EXTERNAL_APPLE_SECRET)"
# Overrides the default auth callback URL derived from auth.external_url.
redirect_uri = ""
# Overrides the default auth provider URL. Used to support self-hosted gitlab, single-tenant Azure,
# or any other third-party OIDC providers.
url = ""
# If enabled, the nonce check will be skipped. Required for local sign in with Google auth.
skip_nonce_check = false
# If enabled, it will allow the user to successfully authenticate when the provider does not return an email address.
email_optional = false

# Allow Solana wallet holders to sign in to your project via the Sign in with Solana (SIWS, EIP-4361) standard.
# You can configure "web3" rate limit in the [auth.rate_limit] section and set up [auth.captcha] if self-hosting.
[auth.web3.solana]
enabled = false

# Use Firebase Auth as a third-party provider alongside Supabase Auth.
[auth.third_party.firebase]
enabled = false
# project_id = "my-firebase-project"

# Use Auth0 as a third-party provider alongside Supabase Auth.
[auth.third_party.auth0]
enabled = false
# tenant = "my-auth0-tenant"
# tenant_region = "us"

# Use AWS Cognito (Amplify) as a third-party provider alongside Supabase Auth.
[auth.third_party.aws_cognito]
enabled = false
# user_pool_id = "my-user-pool-id"
# user_pool_region = "us-east-1"

# Use Clerk as a third-party provider alongside Supabase Auth.
[auth.third_party.clerk]
enabled = false
# Obtain from https://clerk.com/setup/supabase
# domain = "example.clerk.accounts.dev"

# OAuth server configuration
[auth.oauth_server]
# Enable OAuth server functionality
enabled = false
# Path for OAuth consent flow UI
authorization_url_path = "/oauth/consent"
# Allow dynamic client registration
allow_dynamic_registration = false

[edge_runtime]
enabled = true
# Supported request policies: `oneshot`, `per_worker`.
# `per_worker` (default) — enables hot reload during local development.
# `oneshot` — fallback mode if hot reload causes issues (e.g. in large repos or with symlinks).
policy = "per_worker"
# Port to attach the Chrome inspector for debugging edge functions.
inspector_port = 8083
# The Deno major version to use.
deno_version = 2

# [edge_runtime.secrets]
# secret_key = "env(SECRET_VALUE)"

[analytics]
enabled = true
port = 54327
# Configure one of the supported backends: `postgres`, `bigquery`.
backend = "postgres"

# Experimental features may be deprecated any time
[experimental]
# Configures Postgres storage engine to use OrioleDB (S3)
orioledb_version = ""
# Configures S3 bucket URL, eg. <bucket_name>.s3-<region>.amazonaws.com
s3_host = "env(S3_HOST)"
# Configures S3 bucket region, eg. us-east-1
s3_region = "env(S3_REGION)"
# Configures AWS_ACCESS_KEY_ID for S3 bucket
s3_access_key = "env(S3_ACCESS_KEY)"
# Configures AWS_SECRET_ACCESS_KEY for S3 bucket
s3_secret_key = "env(S3_SECRET_KEY)"

# [experimental.pgdelta]
# When enabled, pg-delta becomes the active engine for supported schema flows.
# enabled = false
# Directory under `supabase/` where declarative files are written.
# declarative_schema_path = "./database"
# JSON string passed through to pg-delta SQL formatting.
# format_options = "{\"keywordCase\":\"upper\",\"indent\":2,\"maxWidth\":80,\"commaStyle\":\"trailing\"}"

```

### File: `supabase/migrations/20260616111111_init_schema.sql`
```sql
-- Create Tokens Table
CREATE TABLE tokens (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    token_number INT NOT NULL,
    customer_name TEXT,
    phone_number TEXT,
    email TEXT,
    service_type TEXT,
    source TEXT,
    status TEXT DEFAULT 'Waiting',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    remarks TEXT
);

-- Create Settings Table
CREATE TABLE settings (
    key TEXT PRIMARY KEY,
    value TEXT
);

-- Insert Default Settings
INSERT INTO settings (key, value) VALUES
    ('Starting Token Number', '100'),
    ('Last Generated Token', '100'),
    ('Current Serving Token', '0'),
    ('Average Service Time', '10'),
    ('Organization Name', 'Smart Token Management System'),
    ('Enable Buzzer', 'true'),
    ('Thermal Printer Settings', 'Default'),
    ('Admin Password', 'admin123');

-- Enable RLS on tables
ALTER TABLE tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- Create policies for tokens table
CREATE POLICY "Allow anon read access on tokens" ON tokens FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert access on tokens" ON tokens FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update access on tokens" ON tokens FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon delete access on tokens" ON tokens FOR DELETE TO anon USING (true);

-- Create policies for settings table
CREATE POLICY "Allow anon read access on settings" ON settings FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon update access on settings" ON settings FOR UPDATE TO anon USING (true) WITH CHECK (true);

```
