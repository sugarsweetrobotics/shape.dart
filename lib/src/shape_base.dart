library shape.base;

import 'dart:html' as html;
import 'dart:math' as math;

class DrawContext {
  
  DrawContext() {}
  
  void set lineWidth(num v) {}
  
  void set fillColor(Color c) {}
  
  void set storokeColor(Color c) {}
  
  void drawRect(Rectangle rectangle, {bool fill : false}) {
  }
  
  void drawCircle(Circle circle, {bool fill : false}) {
  }
  
  void drawPolygon(Polygon polygon, {bool fill : false}) {
  }
  
  void drawText(Text textShape) {
  }
}

class CanvasDrawContext extends DrawContext {
  
  html.CanvasElement canvas;
  
  String font = 'Arial';

  void set lineWidth(num v) {
    canvas.context2D.lineWidth = v;
  }
  
  void set fillColor(Color c) {
    canvas.context2D.fillStyle = c.toString();
  }
  
  void set storokeColor(Color c) {
    canvas.context2D.strokeStyle = '${c.toString()} ${font}';
  }
  
  CanvasDrawContext(this.canvas) {}
  
  void drawRect(Rectangle rect, {bool fill : false}) {
    canvas.context2D.strokeRect(rect.x, rect.y, rect.width, rect.height);
    if(fill) {
      canvas.context2D.fillRect(rect.x, rect.y, rect.width, rect.height);
    }
  }
  
  void drawCircle(Circle circle, {bool fill : false}) {
    canvas.context2D.arc(circle.center.x, circle.center.y, circle.radius, 0, 2*math.PI);
    if(fill) {
      canvas.context2D.fill();
    }
  }
  
  void drawPolygon(Polygon polygon, {bool fill : false}) {
    var c2d = canvas.context2D;
    c2d.moveTo(polygon.points[0].x, polygon.points[0].y);
    for(int i = 1;i < polygon.points.length;i++) {
      c2d.lineTo(polygon.points[i].x, polygon.points[i].y);
    }
    c2d.lineTo(polygon.points[0].x, polygon.points[0].y);
    c2d.stroke();
    if(fill) {
      c2d.fill();
    }
  }
  
  void drawText(Text textShape) {
    var c2d = canvas.context2D;
    c2d.lineWidth = 1;
    c2d.textAlign = textShape.textAlign;
    c2d.font = textShape.font;
    if(textShape.color != null) {
      c2d.fillStyle = textShape.color.toString();
    }
    c2d.fillText(textShape.text,textShape.x, textShape.y);
  }
}


class Point2D {
  num x;
  num y;
  Point2D(this.x, this.y) {}
  
  Point2D translate(num x, num y) {
    return new Point2D(this.x + x, this.y + y);
  }
  
  Point2D clone() {
    return new Point2D(x, y);
  }
}

num distance(Point2D x, Point2D x0) {
  num dx = x.x - x0.x;
  num dy = x.y - x0.y;
  return math.sqrt(dx*dx + dy*dy);
}

class Color {
  num r;
  num g;
  num b;
  num a = 1;
  Color(this.r, this.g, this.b, [this.a]) {}
  
  String toString() {
    return "rgb(${r},${g},${b}";
  }
  
  Color.black() {
    r = g = b = 0;
  }
}

class Shape2D {
  Shape2D() {}
  void draw(DrawContext context, {fill : false}) {}
  Shape2D translate(num x, num y) { return null;}
  Shape2D stretch(num percent) { return null;}
}

class Text extends Shape2D {
  
  num x;
  num y;
  String text;
  String font;
  String textAlign;
  Color color;
  
  Text(this.text, {this.font : '14px Arial', this.textAlign: 'left', this.x : 0, this.y : 0, this.color : null}) {}
  
  Shape2D translate(num x, num y) {
    return new Text(this.text)
    ..font = this.font
    ..textAlign = this.textAlign
    ..x = x
    ..y = y;
  }
  
  void draw(DrawContext context, {fill : false}) {
    context.drawText(this);
  }
}

class Rectangle extends Shape2D {
  num x;
  num y;
  num width;
  num height;
  
  Rectangle(this.x, this.y, this.width, this.height) {
  }
  
  void draw(DrawContext context, {fill : false}) {
    context.drawRect(this, fill: fill);
  }
  
  Shape2D stretch(num percent) {
    return new Rectangle(x, y, width*percent, height*percent);
  }
  
  Shape2D translate(num x, num y) {
    return new Rectangle(this.x + x, this.y + y, width, height);
  }
}

class Circle extends Shape2D {
  Point2D center;
  num radius;
  
  Circle(this.center, this.radius) {}
  
  void draw(DrawContext context, {fill : false}) {
    context.drawCircle(this, fill: fill);
  }
  
  Shape2D stretch(num percent) {
    return new Circle(center, radius*percent);
  }
  
  Shape2D translate(num x, num y) {
    return new Circle(center.translate(x, y), radius);    
  }
}

class Polygon extends Shape2D {
  List<Point2D> points;
  
  Polygon(List<Point2D> points) {
    this.points = points;
  }
  
  
  static Polygon fromPoints(List<Point2D> points) {
    var ps = new List<Point2D>();
    points.forEach((p) {
      ps.add(p.clone());
    });
    return new Polygon(ps);
  }
  
  static Polygon fromNums(List<num> xs, List<num> ys) {
    var points = new List<Point2D>();
    int length = xs.length;
    if(xs.length >= ys.length) {length = ys.length;}
    
    for(int i = 0;i < length;i++) {
      points.add(new Point2D(xs[i], ys[i]));
    }
    
    return new Polygon(points);
  }
  
  void draw(DrawContext context, {fill : false}) {
    context.drawPolygon(this, fill: fill);
  }
  
  Shape2D stretch(num percent) {
    var new_points = new List<Point2D>();
    new_points.add(new Point2D(points[0].x, points[0].y));
    for(int i = 1;i < points.length;i++) {
      Point2D x0 = points[i-1];
      Point2D x  = points[i];
      num dx = (x.x - x0.x) * percent;
      num dy = (x.y - x0.y) * percent;
      new_points.add(new Point2D(x0.x + dx, x0.y + dy));
    }
    return new Polygon(new_points);
  }
  
  Shape2D offset(num x, num y) {
    var new_points = new List<Point2D>();
    this.points.forEach((p){
      new_points.add(new Point2D(p.x + x, p.y + y));
    });
    return new Polygon(new_points);
  }
}


