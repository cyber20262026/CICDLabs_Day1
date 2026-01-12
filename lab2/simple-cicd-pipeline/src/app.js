const express = require('express');
const app = express();
const PORT = 3000;
// small change 4

// Simple welcome page
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to Simple CI/CD Demo!',
    version: '1.0.0'
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString()
  });
});

// Simple API endpoint
app.get('/api/hello', (req, res) => {
  res.json({
    greeting: 'Hello from CI/CD Pipeline!',
    success: true
  });
});

// Start server (only if not in test mode)
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

module.exports = app;
