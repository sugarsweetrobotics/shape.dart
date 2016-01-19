part of shape;


abstract class Shape2D {

  num strokeWidth = 1;
  Color strokeColor = new Color.black();
  Color fillColor = new Color.white();

  void move(num x, num y);

  void stretch(num percent);

  void rotate(num angleRadian, {Point2D center: null}) {}

  void draw(DrawContext context, {fill : false, styleHolder : null}) {
    context.draw(this, fill: fill, styleHolder : styleHolder);
  }
}


class Color {
  num r;
  num g;
  num b;
  num a = 1;
  Color(this.r, this.g, this.b, [this.a]) {}

  String toString() {
    return "rgb(${r},${g},${b})";
  }

  Color.fromString(String s) {
    if (s.startsWith('#')) {
      if (s.length == 7) {
        var rs = s.substring(1,3);
        var gs = s.substring(3,5);
        var bs = s.substring(5,7);
        r = int.parse(rs, radix: 16);
        g = int.parse(gs, radix: 16);
        b = int.parse(bs, radix: 16);
      }
    }
  }


  Color.black() {
    r = g = b = 0;
  }

  Color.white() {
    r = g = b = 255;
  }
}


abstract class DrawContext {

  DrawContext() {}

  num getStrokeWidth();
  void setStrokeWidth(num w);
  Color getFillColor();
  void setFillColor(Color c);
  Color getStrokeColor();
  void setStrokeColor(Color c);

  void drawLine(Point2D x0, Point2D x1) {}

  void draw(Shape2D shape, {bool fill: false, Shape2D styleHolder : null}) {
    var sw = getStrokeWidth();
    var fc = getFillColor();
    var sc = getStrokeColor();

    if (styleHolder == null) {
      styleHolder = shape;
    }

    setStrokeWidth(styleHolder.strokeWidth);
    setStrokeColor(styleHolder.strokeColor);
    setFillColor(styleHolder.fillColor);

    if (shape is Rectangle) { drawRect(shape, fill:fill);}
    else if (shape is Arc) { drawArc(shape, fill:fill);}
    else if (shape is Circle) { drawCircle(shape, fill:fill);}
    else if (shape is Polygon) { drawPolygon(shape, fill:fill);}
    else if (shape is Text) { drawText(shape);}
    else if (shape is StraightArrow) { drawStraightArrow(shape, fill:fill);}
    else if (shape is ArcArrow) { drawArcArrow(shape, fill:fill);}

    setStrokeWidth(sw);
    setStrokeColor(sc);
    setFillColor(fc);
  }

  void drawRect(Rectangle rectangle, {bool fill : false});

  void drawCircle(Circle circle, {bool fill : false});

  void drawArc(Arc arc, {bool fill : false});

  void drawPolygon(Polygon polygon, {bool fill : false});

  void drawText(Text textShape);

  void drawStraightArrow(StraightArrow arrow, {bool fill : false});

  void drawArcArrow(ArcArrow arrow, {bool fill : false});
}