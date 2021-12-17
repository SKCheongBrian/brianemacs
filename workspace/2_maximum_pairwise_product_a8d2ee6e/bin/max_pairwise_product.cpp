#include <iostream>
#include <vector>
#include <algorithm>

long long MaxPairwiseProduct(const std::vector<int>& numbers) {
    int n = numbers.size();

    int maxIndex = 0;
    int secondIndex = 0;

    int val = 0;

    for (int i = 0; i < n; i++) {
      if (numbers[i] > val) {
	maxIndex = i;
	val = numbers[i];
      }
    }

    val = 0;

    for (int i = 0; i < n; i++) {
      if (numbers[i] > val && i != maxIndex) {
	secondIndex = i;
	val = numbers[i];
      }
    }

    return (long long)numbers[maxIndex] * numbers[secondIndex];
}

int main() {
    int n;
    std::cin >> n;
    std::vector<int> numbers(n);
    for (int i = 0; i < n; ++i) {
        std::cin >> numbers[i];
    }

    std::cout << MaxPairwiseProduct(numbers) << "\n";
    return 0;
}
