#!/bin/bash
# This script runs automatically when EC2 instance first boots

# Update all system packages to latest versions
yum update -y

# Install Apache web server
yum install -y httpd

# Start Apache and enable it to start on boot
systemctl start httpd
systemctl enable httpd

# Create a custom dark, modern webpage
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS Infrastructure | Terraform Deployed</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #0a0a0a;
            color: #e5e5e5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            width: 100%;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .status-badge {
            display: inline-block;
            background: #10b981;
            color: #000;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 20px;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }

        h1 {
            font-size: 3.5em;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #10b981, #3b82f6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .subtitle {
            color: #737373;
            font-size: 1.2em;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 40px;
        }

        .info-card {
            background: #161616;
            border: 1px solid #262626;
            border-radius: 12px;
            padding: 24px;
            transition: all 0.3s ease;
        }

        .info-card:hover {
            border-color: #10b981;
            transform: translateY(-4px);
            box-shadow: 0 10px 30px rgba(16, 185, 129, 0.1);
        }

        .card-label {
            color: #737373;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .card-value {
            color: #e5e5e5;
            font-size: 16px;
            font-family: 'Courier New', monospace;
            word-break: break-all;
        }

        .tech-stack {
            margin-top: 40px;
            padding: 30px;
            background: #161616;
            border: 1px solid #262626;
            border-radius: 12px;
            text-align: center;
        }

        .tech-stack h3 {
            color: #e5e5e5;
            margin-bottom: 20px;
            font-size: 1.2em;
        }

        .tech-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            justify-content: center;
        }

        .tech-badge {
            background: #262626;
            color: #10b981;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            border: 1px solid #404040;
            font-weight: 500;
        }

        .footer {
            margin-top: 40px;
            text-align: center;
            color: #525252;
            font-size: 14px;
        }

        .loading {
            color: #737373;
            font-style: italic;
        }

        @media (max-width: 600px) {
            h1 {
                font-size: 2.5em;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="status-badge">● LIVE</div>
            <h1>Infrastructure Online</h1>
            <p class="subtitle">Deployed via Terraform on AWS</p>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <div class="card-label">Instance ID</div>
                <div class="card-value" id="instanceId"><span class="loading">Loading...</span></div>
            </div>

            <div class="info-card">
                <div class="card-label">Availability Zone</div>
                <div class="card-value" id="az"><span class="loading">Loading...</span></div>
            </div>

            <div class="info-card">
                <div class="card-label">Region</div>
                <div class="card-value">ap-south-1 (Mumbai)</div>
            </div>

            <div class="info-card">
                <div class="card-label">Instance Type</div>
                <div class="card-value">t3.micro</div>
            </div>
        </div>

        <div class="tech-stack">
            <h3>Technology Stack</h3>
            <div class="tech-badges">
                <span class="tech-badge">Terraform</span>
                <span class="tech-badge">AWS VPC</span>
                <span class="tech-badge">EC2</span>
                <span class="tech-badge">Apache</span>
                <span class="tech-badge">Amazon Linux 2</span>
            </div>
        </div>

        <div class="footer">
            <p>Built from scratch with infrastructure as code principles</p>
        </div>
    </div>

    <script>
        // Fetch instance metadata from AWS metadata service
        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(response => response.text())
            .then(data => {
                document.getElementById('instanceId').innerHTML = data;
            })
            .catch(() => {
                document.getElementById('instanceId').innerHTML = '<span style="color: #dc2626;">Unable to fetch</span>';
            });
        
        fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
            .then(response => response.text())
            .then(data => {
                document.getElementById('az').innerHTML = data;
            })
            .catch(() => {
                document.getElementById('az').innerHTML = '<span style="color: #dc2626;">Unable to fetch</span>';
            });
    </script>
</body>
</html>
EOF

# Set proper permissions
chmod 644 /var/www/html/index.html