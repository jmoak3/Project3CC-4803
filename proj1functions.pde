// FROM: http://rsbweb.nih.gov/ij/plugins/download/Color_Space_Converter.java
public double[] D65 = {95.0429, 100.0, 108.8900};
public double[] whitePoint = D65;

public double[][] Mi  = {{ 3.2406, -1.5372, -0.4986},
                         {-0.9689,  1.8758,  0.0415},
                         { 0.0557, -0.2040,  1.0570}};
public double[][] M   = {{0.4124, 0.3576,  0.1805},
                         {0.2126, 0.7152,  0.0722},
                         {0.0193, 0.1192,  0.9505}};

// LAB to color
color LABtoColor(double L, double a, double b) {int [] C= LABtoRGB(L,a,b); return color(min(255,C[0]),min(255,C[1]),min(255,C[2]));}  

// LAB > RGB = (LAB > XYZ) + (XYZ > RGB)
public int[] LABtoRGB(double L, double a, double b) {return XYZtoRGB(LABtoXYZ(L, a, b));}

// LAB > XYZ
public double[] LABtoXYZ(double[] LAB) {return LABtoXYZ(LAB[0], LAB[1], LAB[2]);}
public double[] LABtoXYZ(double L, double a, double b) {
      double[] result = new double[3];
      double y = (L + 16.0) / 116.0;
      double y3 = Math.pow(y, 3.0);
      double x = (a / 500.0) + y;
      double x3 = Math.pow(x, 3.0);
      double z = y - (b / 200.0);
      double z3 = Math.pow(z, 3.0);
      if (y3 > 0.008856) y = y3; else y = (y - (16.0 / 116.0)) / 7.787;
      if (x3 > 0.008856) x = x3; else x = (x - (16.0 / 116.0)) / 7.787;
      if (z3 > 0.008856) z = z3; else z = (z - (16.0 / 116.0)) / 7.787;
      result[0] = x * whitePoint[0];
      result[1] = y * whitePoint[1];
      result[2] = z * whitePoint[2];
      return result;
      }

// LAB > LCH (from http://www.brucelindbloom.com/index.html?Equations.html)
public double[] LABtoLCH(double[] LAB) {return LABtoLCH(LAB[0], LAB[1], LAB[2]);}
public double[] LABtoLCH(double L, double a, double b) {
      double[] result = new double[3];
      double h = Math.atan2(b, a);
      // convert radians to degrees
      if (h > 0) h = Math.toDegrees(h);
      else if (h < 0) h = 360 - Math.toDegrees(Math.abs(h));
      if (h < 0) h += 360;
      else if (h >= 360) h -= 360;
      result[0] = L;
      result[1] = Math.sqrt(a*a + b*b);
      result[2] = h;
      return result;
      }

// LCH to color
color LCHtoColor(double L, double c, double h) {int [] C= LCHtoRGB(L,c,h); return color(C[0],C[1],C[2]);}

// LCH > RGB = (LCH > LAB) + (LAB > XYZ) + (XYZ > RGB)
public int[] LCHtoRGB(double L, double c, double h) {return XYZtoRGB(LABtoXYZ(LCHtoLAB(L, c, h)));}

// LCH > LAB (from http://www.brucelindbloom.com/index.html?Equations.html)
public double[] LCHtoLAB(double L, double c, double h) {
      double[] result = new double[3];
      h = Math.toRadians(h);
      result[0] = L;
      result[1] = c * Math.cos(h);
      result[2] = c * Math.sin(h);
      return result;
      }

// XYZ to color
color XYZtoColor(double X, double Y, double Z) {int [] C= XYZtoRGB(X,Y,Z); return color(C[0],C[1],C[2]);}

// XYZ > RGB    
public int[] XYZtoRGB(double[] XYZ) {return XYZtoRGB(XYZ[0], XYZ[1], XYZ[2]);}
public int[] XYZtoRGB(double X, double Y, double Z) {
      int[] result = new int[3];
      double x = X / 100.0;
      double y = Y / 100.0;
      double z = Z / 100.0;
      // [r g b] = [X Y Z][Mi]
      double r = (x * Mi[0][0]) + (y * Mi[0][1]) + (z * Mi[0][2]);
      double g = (x * Mi[1][0]) + (y * Mi[1][1]) + (z * Mi[1][2]);
      double b = (x * Mi[2][0]) + (y * Mi[2][1]) + (z * Mi[2][2]);
      // assume sRGB
      if (r > 0.0031308) r = ((1.055 * Math.pow(r, 1.0 / 2.4)) - 0.055); else r = (r * 12.92);
      if (g > 0.0031308) g = ((1.055 * Math.pow(g, 1.0 / 2.4)) - 0.055); else g = (g * 12.92);
      if (b > 0.0031308) b = ((1.055 * Math.pow(b, 1.0 / 2.4)) - 0.055); else b = (b * 12.92);
      r = (r < 0) ? 0 : r;
      r = (r > 1) ? 1 : r;
      g = (g < 0) ? 0 : g;
      g = (g > 1) ? 1 : g;
      b = (b < 0) ? 0 : b;
      b = (b > 1) ? 1 : b;
      // convert 0..1 into 0..255
      result[0] = (int) Math.round(r * 255);
      result[1] = (int) Math.round(g * 255);
      result[2] = (int) Math.round(b * 255);
      return result;
      }
 
    
// RGB > LAB = (RGB > XYZ) + (XYZ > LAB)
public double[] RGBtoLAB(int R, int G, int B) {return XYZtoLAB(RGBtoXYZ(R, G, B));}

// RGB > LCH = (RGB > XYZ) + (XYZ > LAB) + (LAB > LCH)
public double[] RGBtoLCH(int R, int G, int B) {return LABtoLCH(XYZtoLAB(RGBtoXYZ(R, G, B)));}

// RGB > XYZ
public double[] RGBtoXYZ(int R, int G, int B) {
      double[] result = new double[3];
      // convert 0..255 into 0..1
      double r = R / 255.0;
      double g = G / 255.0;
      double b = B / 255.0;
      // assume sRGB
      if (r <= 0.04045) r = r / 12.92; else r = Math.pow(((r + 0.055) / 1.055), 2.4);
      if (g <= 0.04045) g = g / 12.92; else g = Math.pow(((g + 0.055) / 1.055), 2.4);
      if (b <= 0.04045) b = b / 12.92; else b = Math.pow(((b + 0.055) / 1.055), 2.4);
      r *= 100.0;
      g *= 100.0;
      b *= 100.0;
      // [X Y Z] = [r g b][M]
      result[0] = (r * M[0][0]) + (g * M[0][1]) + (b * M[0][2]);
      result[1] = (r * M[1][0]) + (g * M[1][1]) + (b * M[1][2]);
      result[2] = (r * M[2][0]) + (g * M[2][1]) + (b * M[2][2]);
      return result;
      }

// XYZ > LAB
public double[] XYZtoLAB(double[] XYZ) {return XYZtoLAB(XYZ[0], XYZ[1], XYZ[2]);}
public double[] XYZtoLAB(double X, double Y, double Z) {
      double x = X / whitePoint[0];
      double y = Y / whitePoint[1];
      double z = Z / whitePoint[2];
      if (x > 0.008856) x = Math.pow(x, 1.0 / 3.0); else x = (7.787 * x) + (16.0 / 116.0);
      if (y > 0.008856) y = Math.pow(y, 1.0 / 3.0); else y = (7.787 * y) + (16.0 / 116.0);
      if (z > 0.008856) z = Math.pow(z, 1.0 / 3.0); else z = (7.787 * z) + (16.0 / 116.0);
      double[] result = new double[3];
      result[0] = (116.0 * y) - 16.0;
      result[1] = 500.0 * (x - y);
      result[2] = 200.0 * (y - z);
      return result;
      }


// lightness: 0<L<100, cyan-magenta: -100<a<100, blue-yellow: -100<b<100
float L=74,a=5, b=5; 
float L0=57, a0=-88, b0=-91;
float L1=74, a1=95, b1=65;

color RGBramp(int R0, int G0, int B0, int R1, int G1, int B1, float s) {return color((1.-s)*R0+s*R1,(1.-s)*G0+s*G1,(1.-s)*B0+s*B1); }
color XYZramp(int R0, int G0, int B0, int R1, int G1, int B1, float s) {
  double[] XYZ0 = RGBtoXYZ(R0, G0, B0), XYZ1 = RGBtoXYZ(R1, G1, B1);
  return XYZtoColor((1.-s)*XYZ0[0]+s*XYZ1[0],(1.-s)*XYZ0[1]+s*XYZ1[1],(1.-s)*XYZ0[2]+s*XYZ1[2]); 
  }
color LABramp(int R0, int G0, int B0, int R1, int G1, int B1, float s) {
  double[] LAB0 = RGBtoLAB(R0, G0, B0), LAB1 = RGBtoLAB(R1, G1, B1);
  return LABtoColor((1.-s)*LAB0[0]+s*LAB1[0],(1.-s)*LAB0[1]+s*LAB1[1],(1.-s)*LAB0[2]+s*LAB1[2]); 
  } 
color ModifiedLABramp(int R0, int G0, int B0, int R1, int G1, int B1, float s) {
  double[] LAB0 = RGBtoLAB(R0, G0, B0), LAB1 = RGBtoLAB(R1, G1, B1);
  s = pow(s, 2); 
  //s = pow((s-0.5), 3)/(0.5*0.5) + 0.5;
  if (s>1) s = 1.0;
  return LABtoColor((1.-s)*LAB0[0]+s*LAB1[0],(1.-s)*LAB0[1]+s*LAB1[1],(1.-s)*LAB0[2]+s*LAB1[2]);
  } 
/**color LCHramp(int R0, int G0, int B0, int R1, int G1, int B1, float s) {
  double[] LCH0 = RGBtoLCH(R0, G0, B0), LCH1 = RGBtoLCH(R1, G1, B1);
  return LCHtoColor((1.-s)*LCH0[0]+s*LCH1[0],(1.-s)*LCH0[1]+s*LCH1[1],(1.-s)*LCH0[2]+s*LCH1[2]); 
  }*/ 
color LCHramp(int R0, int G0, int B0, int R1, int G1, int B1, float s) {
  double[] LCH0 = RGBtoLCH(R0, G0, B0), LCH1 = RGBtoLCH(R1, G1, B1);
  double d = LCH1[2] - LCH0[2];
  d = d > 180 ? d - 360 : d;
  return LCHtoColor((1.-s)*LCH0[0]+s*LCH1[0],(1.-s)*LCH0[1]+s*LCH1[1], LCH0[2]+s*d ); 
  } 
  
int redC(color c) {return int (c >> 16 & 0xFF); } 
int greenC(color c) {return int (c >> 8 & 0xFF); }  
int blueC(color c) {return int (c & 0xFF); } 

color getThirdColor(color c1, color c2, float s) {
  double[] l1 = RGBtoLAB(redC(c1), greenC(c1), blueC(c1));
  double[] l2 = RGBtoLAB(redC(c2), greenC(c2), blueC(c2));    
  pt A = P((float)l1[0], (float)l1[1], (float)l1[2]);   
  pt B = P((float)l2[0], (float)l2[1], (float)l2[2]); 
  vec AB = V(A,B);
  float L = n(AB);
  
  pt M = P(A, 0.5, AB);
  
  vec AO = V(-A.x, -A.y, -A.z);
  vec BO = V(-B.x, -B.y, -B.z);
  vec R = R(V(M,B), PI/2.0, AB, AO).normalize();
  vec N = N(V(M,B), R).normalize();
  vec v = R(N, s*2.0*PI, N, R).normalize();
  pt f = P(M, L*0.3, v);
  
  return LABtoColor(f.x, f.y, f.z);
  
  }