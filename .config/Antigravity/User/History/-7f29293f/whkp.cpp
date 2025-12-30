/* Surface Area Calculator */

#include <iostream>
using namespace std;

/* Coefficients Initialization */

// Only Works For First Octant

int main() {
  double A, B, C,
      K; // A = x_coefficent, B = y_coefficent, C = z_coefficent, K = constant
  double a, b, c; // power of x, y, z
  double x, y, z;

  // Equation form Ax + By + Cz = K

  /* Input Coefficients */
  cout << "Enter the coefficients of the equation: " << endl;
  cout << "A: ";
  cin >> A;
  cout << "B: ";
  cin >> B;
  cout << "C: ";
  cin >> C;

  /* Input Constant */
  cout << "Enter the constant: ";
  cin >> K;

  return 0;

  /* Finding Limits */

  double inner_limit = (K - A * x) / B; // y limit
  double outer_limit = K / A;           // x limit
  double surface_function = (K - A * x - B * y) / C;

  /* Functions*/

  double partial_x(double A, double C) { return -A / C; }
  double partial_y(double B, double C) { return -B / C; }
