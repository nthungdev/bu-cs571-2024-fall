#include <iostream>
#include <string>
using namespace std;

// Your program must allocate memory for the two addend vectors and the sum vector on the heap. (The use of C's variable-length arrays VLAs is not acceptable).

// All memory dynamically allocated by your code must be explicitly released before program termination.

// The sum must first be computed into the sum vector before being written to standard output.

// Your program should not assume any maximum limits on N_ENTRIES beyond those dictated by available memory.

void outputVector(size_t size, int *v)
{
  for (int i = 0; i < size; i++)
  {
    cout << v[i] << ' ';
  }
  cout << '\n';
}

int main(int argc, char *argv[])
{
  unsigned int operationsCount = stoi(argv[1]);
  unsigned int entriesCount = stoi(argv[2]);

  for (int i = 0; i < operationsCount; i++)
  {
    int *vector1 = new int[entriesCount];
    int *vector2 = new int[entriesCount];

    for (int i = 0; i < entriesCount; i++)
    {
      cin >> vector1[i];
    }
    for (int i = 0; i < entriesCount; i++)
    {
      cin >> vector2[i];
    }

    int *vector3 = new int[entriesCount];

    // Print the data for verification
    outputVector(entriesCount, vector1);
    outputVector(entriesCount, vector2);

    // Calculate the sum and output
    for (int i = 0; i < entriesCount; i++)
    {
      vector3[i] = vector1[i] + vector2[i];
    }

    outputVector(entriesCount, vector3);

    // Clean up
    delete[] vector1;
    delete[] vector2;
    delete[] vector3;
  }

  return 0;
}