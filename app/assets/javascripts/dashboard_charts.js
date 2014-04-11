var renderChart;

renderChart = function(domId, data, width, height) {
  var g, line, margin, vis, x, y;
  margin = 20;
  y = d3.scale.linear().domain([0, d3.max(data)]).range([0 + margin, height - margin]);
  x = d3.scale.linear().domain([0, data.length]).range([0 + margin, width - margin]);
  vis = d3.select(domId).append("svg:svg").attr("width", width).attr("height", height);
  g = vis.append("svg:g").attr("transform", "translate(0, " + height + ")");
  line = d3.svg.line().x(function(d, i) {
    return x(i);
  }).y(function(d) {
    return -1 * y(d);
  });
  g.append("svg:path").attr("d", line(data));
  g.append("svg:line").attr("x1", x(0)).attr("y1", -1 * y(0)).attr("x2", x(width)).attr("y2", -1 * y(0));
  g.append("svg:line").attr("x1", x(0)).attr("y1", -1 * y(0)).attr("x2", x(0)).attr("y2", -1 * y(d3.max(data)));
  g.selectAll(".xLabel").data(x.ticks(5)).enter().append("svg:text").attr("class", "xLabel").text(String).attr("x", function(d) {
    return x(d);
  }).attr("y", 0).attr("text-anchor", "middle");
  g.selectAll(".yLabel").data(y.ticks(4)).enter().append("svg:text").attr("class", "yLabel").text(String).attr("x", 0).attr("y", function(d) {
    return -1 * y(d);
  }).attr("text-anchor", "right").attr("dy", 4);
  return g.selectAll(".yTicks").data(y.ticks(4)).enter().append("svg:line").attr("class", "yTicks").attr("y1", function(d) {
    return -1 * y(d);
  }).attr("x1", x(width)).attr("y2", function(d) {
    return -1 * y(d);
  }).attr("x2", x(0.05));
};

$.get('/dashboard/api_usage', function(data) {
  return renderChart('#api-chart', data, 300, 120);
});

$.get('/dashboard/system_usage', function(data) {
  return renderChart('#system-usage-chart', data, 650, 120);
});
