# OverInternet - J Cloudflare Tunnel Automation Script

![Banner](https://img.shields.io/badge/Project-OverInternet-blue) ![License](https://img.shields.io/badge/License-JPL-green) ![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)

A powerful Bash script that automatically creates Cloudflare Tunnels to expose your localhost applications over the internet with fresh random URLs each time.

**Repository**: https://github.com/jprojectplatform/J-Cloudflare

## 🚀 Features

- **One-Click Setup**: Expose your localhost with a single command
- **Fresh URLs**: Generates new random URLs for each session
- **No Configuration**: Works out of the box with sensible defaults
- **Automatic Cleanup**: Properly stops tunnels when done
- **Traffic Monitoring**: Real-time connection monitoring
- **Port Flexibility**: Easy to configure for different applications
- **Security Focused**: Temporary access only while script runs

## 📋 Prerequisites

- Linux environment
- `cloudflared` binary in the same directory
- Local application running on specified port
- Internet connection

## ⚡ Quick Start

1. **Download the script**:
```
git clone https://github.com/jprojectplatform/J-Cloudflare.git && cd J-Cloudflare
chmod +x overinternet.sh
bash overinternet.sh
```
2. **Download cloudflared**:
```
bash
curl -L --output cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared
```


3. **Start your application** (on port 5000 by default):
```bash
# Example for Python Flask
python3 app.py

# Example for Node.js
node app.js

# Example for any other application
./your_application
```

4. **Run the tunnel script**:
```bash
./overinternet.sh
```

5. **Share the generated URL** with anyone, anywhere!

## 🔧 Configuration

### Changing Default Port
Edit the `PORT` variable in the script (line 15):
```bash
PORT=3000  # Change to your application's port
```

### Common Port Examples
- **Web Development**: 3000 (React), 4200 (Angular), 8080 (Java)
- **APIs**: 8000 (Django), 3001 (Express.js), 8081 (Spring Boot)
- **Static Sites**: 5000 (Python), 4000 (Jekyll)

## 📖 Usage Examples

### Basic Usage
```bash
./overinternet.sh
```

### With Help
```bash
./overinternet.sh --help
```

### For Different Ports
1. Edit the script to change `PORT=3000`
2. Start your app on port 3000
3. Run: `./overinternet.sh`

## 🎯 What You'll See

When successful, the script displays:
```
🎯 FRESH TUNNEL URL CREATED!
══════════════════════════════════════════════════════════════
https://random-subdomain.trycloudflare.com
══════════════════════════════════════════════════════════════
📋 This URL will work until you stop this script
⏹️  Press Ctrl+C to stop the tunnel
```

## 🔍 Monitoring

The script provides real-time monitoring:
- **New connections** appear in green
- **Errors** are highlighted in red
- **Traffic patterns** are visible in real-time

## 🛠️ Troubleshooting

### Application Not Running
```
❌ localhost:5000 is not responding
💡 Make sure your application is running on port 5000
```

**Solution**: Start your application first, then run the script.

### Cloudflared Not Found
```
❌ cloudflared binary not found in current directory
```

**Solution**: Download cloudflared as shown in prerequisites.

### Port Already in Use
```bash
netstat -tulpn | grep :5000
```

**Solution**: Change port or stop the conflicting service.

## 📁 File Structure

```
J-Cloudflare/
├── overinternet.sh          # Main script
├── cloudflared             # Cloudflare binary 
├── cloudflared.log         # Generated log file
└── latest_tunnel_url.txt   # Last generated URL
```

## 🔒 Security Notes

- URLs are **temporary** and expire when script stops
- Each run generates a **new random subdomain**
- No persistent access after Ctrl+C
- Perfect for **demos**, **testing**, and **temporary sharing**

## 🌐 Use Cases

- **Demo Presentations**: Share your work with clients
- **Team Collaboration**: Temporary access for teammates
- **Mobile Testing**: Test on real devices
- **CI/CD Pipelines**: Temporary staging environments
- **Educational Purposes**: Live coding demonstrations

## 📞 Support

- **Repository**: https://github.com/jprojectplatform/J-Cloudflare
- **Issues**: Use GitHub Issues for bug reports
- **Contributions**: Pull requests welcome!

## 📄 License

This project is licensed under the **J PROJECT LICENSE (JPL)**.

## 🏆 Credits

**Created by jh4ck3r from J Project Platform**  
**Website**: https://jprojectplatform.com/

---

**⭐ Star this repository if you find it useful!**

*Part of the J Project Platform - Building tools for developers*
