const http = require("http");
const app = require("./app");

const port = process.env.PORT || "3000";

app.set("port", port);

let httpServer = http.createServer(app);

httpServer.listen(port, () => {
  // successLogger(`API running on port ${port}, DateTime : ${new Date()}`);
  console.log("API running on port", port);
});
