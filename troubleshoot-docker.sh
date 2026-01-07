#!/bin/bash

echo "========================================="
echo "Drupal Docker Troubleshooting Script"
echo "========================================="
echo ""

# Check if Docker is running
echo "1. Checking Docker status..."
if ! docker info > /dev/null 2>&1; then
    echo "   ❌ Docker is not running or not accessible"
    exit 1
else
    echo "   ✅ Docker is running"
fi

# Check if docker-compose is available
echo ""
echo "2. Checking docker-compose..."
if ! command -v docker-compose &> /dev/null; then
    echo "   ⚠️  docker-compose not found, trying 'docker compose'..."
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
    echo "   ✅ docker-compose found"
fi

# Check if containers are running
echo ""
echo "3. Checking container status..."
$DOCKER_COMPOSE ps

# Check if web container is running
if docker ps | grep -q "drupal-food-rescue-demo.*web"; then
    echo "   ✅ Web container is running"
    WEB_CONTAINER=$(docker ps | grep "drupal-food-rescue-demo.*web" | awk '{print $1}')
else
    echo "   ❌ Web container is NOT running"
    echo ""
    echo "   Attempting to start containers..."
    $DOCKER_COMPOSE up -d
    sleep 5
    if docker ps | grep -q "drupal-food-rescue-demo.*web"; then
        echo "   ✅ Containers started successfully"
        WEB_CONTAINER=$(docker ps | grep "drupal-food-rescue-demo.*web" | awk '{print $1}')
    else
        echo "   ❌ Failed to start containers"
        echo ""
        echo "   Checking logs..."
        $DOCKER_COMPOSE logs --tail=50 web
        exit 1
    fi
fi

# Check Apache status inside container
echo ""
echo "4. Checking Apache status inside container..."
if docker exec $WEB_CONTAINER ps aux | grep -q "[a]pache2"; then
    echo "   ✅ Apache is running inside container"
else
    echo "   ❌ Apache is NOT running inside container"
    echo "   Attempting to start Apache..."
    docker exec $WEB_CONTAINER service apache2 start
    sleep 2
    if docker exec $WEB_CONTAINER ps aux | grep -q "[a]pache2"; then
        echo "   ✅ Apache started successfully"
    else
        echo "   ❌ Failed to start Apache"
        echo "   Checking Apache error logs..."
        docker exec $WEB_CONTAINER tail -20 /var/log/apache2/error.log
    fi
fi

# Check port binding
echo ""
echo "5. Checking port binding..."
if netstat -tuln 2>/dev/null | grep -q ":8080" || ss -tuln 2>/dev/null | grep -q ":8080"; then
    echo "   ✅ Port 8080 is listening"
    netstat -tuln 2>/dev/null | grep ":8080" || ss -tuln 2>/dev/null | grep ":8080"
else
    echo "   ❌ Port 8080 is NOT listening"
    echo "   This could be a port binding issue"
fi

# Test local connection
echo ""
echo "6. Testing local connection to container..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200\|301\|302"; then
    echo "   ✅ Container is responding on localhost:8080"
else
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
    echo "   ❌ Container is NOT responding properly (HTTP $HTTP_CODE)"
    echo "   Response:"
    curl -s http://localhost:8080 | head -20
fi

# Check container logs
echo ""
echo "7. Recent container logs (last 20 lines)..."
$DOCKER_COMPOSE logs --tail=20 web

# Check Apache configuration
echo ""
echo "8. Checking Apache configuration..."
docker exec $WEB_CONTAINER apache2ctl -S 2>&1 | head -10

# Check document root
echo ""
echo "9. Checking document root..."
docker exec $WEB_CONTAINER ls -la /var/www/html/web/ | head -10

# Check if index.php exists
echo ""
echo "10. Checking for Drupal files..."
if docker exec $WEB_CONTAINER test -f /var/www/html/web/index.php; then
    echo "   ✅ index.php exists"
else
    echo "   ❌ index.php NOT found"
fi

# Check EC2 security group (if on EC2)
echo ""
echo "11. EC2 Security Group Check..."
echo "   ⚠️  Please verify in AWS Console:"
echo "   - Security group allows inbound traffic on port 8080"
echo "   - Source: 0.0.0.0/0 (or your IP) for HTTP"
echo ""
echo "   To check from command line:"
echo "   aws ec2 describe-security-groups --group-ids <your-sg-id>"

# Check firewall (UFW)
echo ""
echo "12. Checking UFW firewall status..."
if command -v ufw &> /dev/null; then
    UFW_STATUS=$(sudo ufw status | head -1)
    echo "   $UFW_STATUS"
    if echo "$UFW_STATUS" | grep -q "Status: active"; then
        echo "   ⚠️  UFW is active. Check if port 8080 is allowed:"
        echo "   sudo ufw allow 8080/tcp"
    fi
else
    echo "   ℹ️  UFW not installed or not accessible"
fi

# Final recommendations
echo ""
echo "========================================="
echo "Troubleshooting Summary"
echo "========================================="
echo ""
echo "Common fixes:"
echo "1. If containers aren't running: docker-compose up -d"
echo "2. If Apache isn't running: docker exec <container> service apache2 start"
echo "3. If port 8080 isn't accessible:"
echo "   - Check AWS Security Group allows port 8080"
echo "   - Check UFW: sudo ufw allow 8080/tcp"
echo "   - Check iptables: sudo iptables -L -n"
echo "4. View logs: docker-compose logs -f web"
echo "5. Rebuild containers: docker-compose up -d --build"
echo ""
echo "To access your site:"
echo "  - From EC2: http://localhost:8080"
echo "  - From internet: http://<EC2-PUBLIC-IP>:8080"
echo ""


