#include <iostream>

using namespace std;

void outputVector(unsigned int size, int *v)
{
  for (unsigned int i = 0; i < size; i++)
  {
    cout << v[i];
    if (i != size - 1)
    {
      cout << " ";
    }
  }
  cout << "\n";
}

int main(int argc, char *argv[])
{
  unsigned int operationsCount = stoi(argv[1]);
  unsigned int entriesCount = stoi(argv[2]);

  for (unsigned int i = 0; i < operationsCount; i++)
  {
    int *vector1 = new int[entriesCount];
    int *vector2 = new int[entriesCount];

    for (unsigned int i = 0; i < entriesCount; i++)
    {
      cin >> vector1[i];
    }
    for (unsigned int i = 0; i < entriesCount; i++)
    {
      cin >> vector2[i];
    }

    int *vector3 = new int[entriesCount];

    // // Print the data for verification
    // outputVector(entriesCount, vector1);
    // outputVector(entriesCount, vector2);

    // Calculate the sum and output
    for (unsigned int i = 0; i < entriesCount; i++)
    {
      vector3[i] = vector1[i] + vector2[i];
    }

    outputVector(entriesCount, vector3);

    if (i < operationsCount - 1)
    {
      cout << "\n";
    }

    // Clean up
    delete[] vector1;
    delete[] vector2;
    delete[] vector3;
  }

  return 0;
}