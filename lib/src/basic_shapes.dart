part of shape;


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



class Text extends Shape2D {

  num x;
  num y;
  String text;
  String font;
  String textAlign;
  Color color;

  Text(this.text, {this.font : '14px Arial', this.textAlign: 'left', this.x : 0, this.y : 0, this.color : null}) {
    fillColor = color;
  }

  void move(num x, num y) {
    this.x += x;
    this.y += y;
  }

  void rotate(num angleRadian, {Point2D center : null}) {

  }

  void stretch(num percent) {}
}


class Circle extends Shape2D {
  Point2D center;
  num radius;

  Circle(this.center, this.radius) {}

  void move(num x, num y) {
    this.center.x += x;
    this.center.y += y;
  }

  void stretch(num percent) {
    radius*=percent;
  }

  void rotate(num angleRadian, {Point2D center : null}) {
  }
}


class Arc extends Shape2D {
  Point2D center;
  num radius;
  num startAngle;
  num stopAngle;
  bool ccw;

  Arc(this.center, this.radius, this.startAngle, this.stopAngle, {ccw : false}) {
    this.ccw = ccw;
  }

  void move(num x, num y) {
    this.center.x += x;
    this.center.y += y;
  }

  void stretch(num percent) {
    radius*=percent;
  }

  void rotate(num angleRadian, {Point2D center : null}) {
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



  void stretch(num percent) {
    var new_points = new List<Point2D>();
    new_points.add(new Point2D(points[0].x, points[0].y));
    for(int i = 1;i < points.length;i++) {
      Point2D x0 = points[i-1];
      Point2D x  = points[i];
      num dx = (x.x - x0.x) * percent;
      num dy = (x.y - x0.y) * percent;
      new_points.add(new Point2D(x0.x + dx, x0.y + dy));
    }
    points = new_points;
  }

  void move(num x, num y) {
    var new_points = new List<Point2D>();
    this.points.forEach((p){
      new_points.add(new Point2D(p.x + x, p.y + y));
    });
    points = new_points;
  }

  void rotate(num angleRadian, {Point2D center : null}) {
    if (center == null) {
      center = points[0];
    }
    var cos = math.cos(angleRadian);
    var sin = math.sin(angleRadian);
    move(-center.x, -center.y);

    var new_points = [];
    points.forEach((Point2D p) {
      var x = p.x;
      var y = p.y;
      new_points.add(new Point2D(
          x * cos + y * sin,
          -x * sin + y * cos
      ));
    });

    points = new_points;
    move(center.x, center.y);
  }
}



class Rectangle extends Shape2D {
  num x;
  num y;
  num width;
  num height;

  Polygon polygon;

  Rectangle(this.x, this.y, this.width, this.height) {
    polygon = new Polygon([new Point2D(x,y), new Point2D(x+width, y), new Point2D(x+width, y+height), new Point2D(x, y+height), new Point2D(x,y)]);
  }

  void move(num x, num y) {
    polygon.move(x,y);
  }

  void rotate(num angleRadian, {Point2D center : null}) {
    polygon.rotate(angleRadian, center:center);
  }

  void stretch(num percent) {
    polygon.stretch(percent);
  }
}


class StraightArrow extends Shape2D {
  Point2D startPoint;
  Point2D stopPoint;
  Text text;

  num straightWidth = 40;
  num arrowWidth = 40;
  num fontSize = 22;

  StraightArrow(this.startPoint, this.stopPoint, {Text text : null}) {
    this.text = text;
  }

  get length {
    return distance(startPoint, stopPoint);
  }

  void move(num x, num y) {
    startPoint.x += x;
    stopPoint.x += x;
    startPoint.y += y;
    stopPoint.y += y;
  }

  void rotate(num angleRadian, {Point2D center : null}) {
    if (center == null) {
      center = startPoint;
    }
    move(-center.x, -center.y);
    var x = stopPoint.x;
    var y = stopPoint.y;
    var cos = math.cos(angleRadian);
    var sin = math.sin(angleRadian);
    stopPoint = new Point2D(x * cos + y * sin,
    -x * sin + y * cos);
    move(center.x, center.y);
  }

  void stretch(num percent) {
    var center = startPoint;
    move(-center.x, -center.y);
    stopPoint.x *= percent;
    stopPoint.y *= percent;
    move(center.x, center.y);
  }

}

class ArcArrow extends Shape2D {

  Point2D center;
  num radius;
  num startAngle;
  num stopAngle;
  num bodyWidth;
  num arrowWidth;

  Text text;

  ArcArrow(this.center, this.radius, this.startAngle, this.stopAngle, this.bodyWidth, this.arrowWidth, {this.text : null}) {}

  void move(num x, num y) {
    center.x += x;
    center.y += y;
  }

  void rotate(num angleRadian, {Point2D center : null}) {

  }

  void stretch(num percent) {
    radius *= percent;
  }

}
