class LxcMcp < Formula
  desc "Professional MCP server for LXC/LXD container management - seamless AI integration with Warp Terminal"
  homepage "https://github.com/TB-Warp/lxc-mcp"
  url "https://github.com/TB-Warp/lxc-mcp/archive/refs/tags/v1.0.1.tar.gz"
  version "1.0.1"
  sha256 "49b3815ce0a840d824942424adbbd554bbb70f052a50f9e827cb3e921afc030e"
  
  depends_on "node"

  def install
    # Install all dependencies (including dev deps for TypeScript build)
    system "npm", "install"
    
    # Build TypeScript
    system "npm", "run", "build"
    
    # Install to libexec to avoid conflicts
    libexec.install Dir["*"]
    
    # Create wrapper scripts for both command names
    (bin/"lxc-mcp").write_env_script("#{Formula["node"].opt_bin}/node", 
                                     "#{libexec}/build/index.js")
    (bin/"lxc-mcp-server").write_env_script("#{Formula["node"].opt_bin}/node", 
                                           "#{libexec}/build/index.js")
  end

  def caveats
    <<~EOS
      LXC MCP Server requires LXD to be installed and running:
        
        # Install LXD on macOS:
        # Visit https://lxd.io and download LXD for macOS
        # Or install via multipass/lima for Linux containers
        
        # For testing with remote LXD server:
        lxc remote add myserver <server-url>
        
        # Verify LXD access
        lxc version
        
      To use with Warp AI, add to your MCP configuration:
      {
        "mcpServers": {
          "lxc-mcp": {
            "command": "lxc-mcp",
            "args": []
          }
        }
      }
      
      Both command names are available:
      - lxc-mcp (recommended for AI integration)
      - lxc-mcp-server (legacy compatibility)
    EOS
  end

  test do
    # Test that the server can start and list tools
    output = shell_output("echo '{\"jsonrpc\": \"2.0\", \"id\": 1, \"method\": \"tools/list\", \"params\": {}}' | #{bin}/lxc-mcp 2>/dev/null", 0)
    assert_match "lxc_list", output
    assert_match "lxc_exec", output
    assert_match "lxc_launch", output
    
    # Test legacy name as well
    output2 = shell_output("echo '{\"jsonrpc\": \"2.0\", \"id\": 1, \"method\": \"tools/list\", \"params\": {}}' | #{bin}/lxc-mcp-server 2>/dev/null", 0)
    assert_match "lxc_info", output2
  end
end
