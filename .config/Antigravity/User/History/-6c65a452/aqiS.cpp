/* Surface Area Calculator */

#include <iostream>
using namespace std;

/* Coefficients Initialization */

int main() {
  double x_coefficent, y_coefficent, z_coefficent, constant;
  double x, y, z;

  // Equation form x + y + z = constant

  /* Input Coefficients */
  cout << "Enter the coefficients of the equation: " << endl;
  cout << "x: ";
  cin >> x_coefficent;
  cout << "y: ";
  cin >> y_coefficent;
  cout << "z: ";
  cin >> z_coefficent;

  /* Input Constant */
  cout << "Enter the constant: ";
  cin >> constant;

  return 0;

  /* Z Form */ // z = (constant - (x_coefficent * x) - (y_coefficent *
               // y))/z_coefficent
}
