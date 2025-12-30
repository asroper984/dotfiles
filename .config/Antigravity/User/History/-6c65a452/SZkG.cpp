/* Surface Area Calculator */

#include <iostream>
using namespace std;

/* Coefficients Initialization */

int main() {
  double A, B, C,
      K; // A = x_coefficent, B = y_coefficent, C = z_coefficent, K = constant
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
}
