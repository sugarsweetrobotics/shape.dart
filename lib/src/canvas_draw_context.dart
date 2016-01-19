part of shape;



class CanvasDrawContext extends DrawContext {
  
  html.CanvasElement canvas;
  
  String font = 'Arial';


  void setFillColor(Color c) {
    canvas.context2D.fillStyle = c.toString();
  }

  void setStrokeWidth(num v) {
    canvas.context2D.lineWidth = v;
  }

  void setStrokeColor(Color c) {
    canvas.context2D.strokeStyle = '${c.toString()}';
  }

  num getStrokeWidth() {
    return canvas.context2D.lineWidth;
  }

  Color getStrokeColor() {
    return new Color.fromString(canvas.context2D.strokeStyle);
  }

  Color getFillColor(){
    return new Color.fromString(canvas.context2D.fillStyle);
  }
  
  CanvasDrawContext(this.canvas) {}

  void drawLine(Point2D x0, Point2D x1) {
    canvas.context2D.moveTo(x0.x, x0.y);
    canvas.context2D.beginPath();
    canvas.context2D.lineTo(x1.x, x1.y);
    canvas.context2D.closePath();
  }

  void drawRect(Rectangle rect, {bool fill : false}) {
    drawPolygon(rect.polygon, fill:fill);

    /*
    var c2d = canvas.context2D;
    c2d.moveTo(rect.x, rect.y);
    if(fill) {
      canvas.context2D.fillRect(rect.x, rect.y, rect.width, rect.height);
    }
    canvas.context2D.strokeRect(rect.x, rect.y, rect.width, rect.height);
    */
  }
  
  void drawCircle(Circle circle, {bool fill : false}) {
    canvas.context2D.moveTo(circle.center.x + circle.radius, circle.center.y);
    if(fill) {
      canvas.context2D.fill();
    }
    canvas.context2D.arc(circle.center.x, circle.center.y, circle.radius, 0, 2*math.PI);
  }

  void drawArc(Arc arc, {bool fill : false}) {
    var c2d = canvas.context2D;
    c2d.moveTo(arc.center.x + arc.radius * math.cos(arc.startAngle), arc.center.y - arc.radius * math.sin(arc.stopAngle));
    canvas.context2D.beginPath();
    canvas.context2D.arc(arc.center.x, arc.center.y, arc.radius, arc.startAngle, arc.stopAngle, arc.ccw);
    if(fill) {
      canvas.context2D.fill();
    }
    canvas.context2D.stroke();
  }
  
  void drawPolygon(Polygon polygon, {bool fill : false}) {
    var c2d = canvas.context2D;
    c2d.moveTo(polygon.points[0].x, polygon.points[0].y);
    c2d.beginPath();
    for(int i = 1;i < polygon.points.length;i++) {
      c2d.lineTo(polygon.points[i].x, polygon.points[i].y);
    }

    c2d.lineTo(polygon.points[0].x, polygon.points[0].y);
    c2d.closePath();
    if(fill) {
      c2d.fill();
    }
    c2d.stroke();
  }
  
  void drawText(Text textShape) {
    var c2d = canvas.context2D;
    var textAlign = c2d.textAlign;
    c2d.textAlign = textShape.textAlign;
    var font = c2d.font;
    c2d.font = textShape.font;
    c2d.fillText(textShape.text,textShape.x, textShape.y);
    c2d.textAlign = textAlign;
    c2d.font = font;
  }

  void drawStraightArrow(StraightArrow arrow, {bool fill : false}) {
    int straight_width = arrow.straightWidth;
    int offset_x = arrow.startPoint.x;
    int offset_y = arrow.startPoint.y - arrow.straightWidth/2;
    int straight_length = arrow.length - arrow.arrowWidth;
    var dx = arrow.stopPoint.x - arrow.startPoint.x;
    var dy = arrow.stopPoint.y - arrow.startPoint.y;
    num th = math.atan2(-dy, dx);
    num arrow_width = arrow.arrowWidth / 2 - arrow.straightWidth/2;
    int arrow_length = arrow.arrowWidth;

    List<Point2D> points = new List<Point2D>();
    Point2D x0 = new Point2D(offset_x, offset_y);
    points.add(x0);
    points.add(new Point2D(x0.x + straight_length, x0.y));
    points.add(new Point2D(x0.x + straight_length, x0.y - arrow_width));
    points.add(new Point2D(x0.x + straight_length + arrow_length, x0.y + straight_width/2));
    points.add(new Point2D(x0.x + straight_length, x0.y + straight_width + arrow_width));
    points.add(new Point2D(x0.x + straight_length, x0.y + straight_width));
    points.add(new Point2D(x0.x, x0.y + straight_width));
    points.add(new Point2D(x0.x, x0.y));
    var p = new Polygon(points);
    p.strokeColor = arrow.strokeColor;
    p.strokeWidth = arrow.strokeWidth;
    p.fillColor = arrow.fillColor;
    p.rotate(th, center: arrow.startPoint);
    p.draw(this, fill:fill);

    if (arrow.text != null) {
      arrow.text.x = (arrow.startPoint.x + arrow.stopPoint.x) /2;
      arrow.text.y = (arrow.startPoint.y + arrow.stopPoint.y) /2 + 5;
      arrow.text.textAlign = 'center';
      print('txt:' + arrow.text.toString());
      arrow.text.draw(this);
    }
  }


  void drawArcArrow(ArcArrow arrow, {bool fill : false}) {
    var c2d = canvas.context2D;
    c2d.moveTo(arrow.center.x + (arrow.radius+arrow.bodyWidth/2) * math.cos(arrow.stopAngle),
        arrow.center.y - (arrow.radius+arrow.bodyWidth/2) * math.sin(arrow.startAngle));
    c2d.beginPath();
    c2d.arc(arrow.center.x, arrow.center.y, arrow.radius - arrow.bodyWidth/2, arrow.stopAngle, arrow.startAngle, true);
    c2d.arc(arrow.center.x, arrow.center.y, arrow.radius + arrow.bodyWidth/2, arrow.startAngle, arrow.stopAngle);

    Polygon p = new Polygon([
      new Point2D(arrow.center.x + arrow.radius + arrow.arrowWidth/2, arrow.center.y),
      new Point2D(arrow.center.x + arrow.radius , arrow.center.y + arrow.arrowWidth),
      new Point2D(arrow.center.x + arrow.radius - arrow.arrowWidth/2, arrow.center.y),
    ]);

    p.rotate(-arrow.stopAngle, center: arrow.center);

    p.points.forEach((Point2D point) {
      c2d.lineTo(point.x, point.y);
    });
    c2d.closePath();
    if(fill) {
      canvas.context2D.fill();
    }
    c2d.stroke();

    if (arrow.text != null) {
      arrow.text.x = arrow.center.x;
      arrow.text.y = arrow.center.y;
      arrow.text.textAlign = 'center';
      arrow.text.draw(this);
    }
  }
}

