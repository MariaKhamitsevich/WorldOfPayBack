//
//  FilterView.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import SwiftUI

struct FilterView: View {
    @State private var isFilterSheetPresented = false
    @State private var isCategoryFilterSheetPresented = false
    @State private var selectedFilter: FilterType
    @State private var selectedCategory: Int
    private let filterOptions: [FilterType]
    private let availableCategories: [Int]
    private var filterHeight: CGFloat {
        CGFloat(FilterType.allCases.count * 28)
    }

    private var categoriesHeight: CGFloat {
        CGFloat(availableCategories.count * 28)
    }

    private var onFilterTypeTap: ((FilterType) -> Void)?
    private var onCategorySelectionTap: ((Int) -> Void)?

    init(
        selectedFilter: FilterType = .dateNewest,
        filterOptions: [FilterType] = FilterType.allCases,
        availableCategories: [Int] = []
    ) {
        self.selectedFilter = selectedFilter
        self.filterOptions = filterOptions
        self.availableCategories = availableCategories
        self.selectedCategory = availableCategories.first ?? 1
    }

    var body: some View {
        HStack(alignment: .center) {
            filterTitle

            chooseFilterOptionButton

            Spacer()

            chooseCategoryButton
        }
        .padding()
        .background {

            Color.white
                .onTapGesture {
                    isFilterSheetPresented = false
                }
        }
        .frame(height: isFilterSheetPresented ? filterHeight : 56)
        .onChange(of: selectedFilter) { newValue in
            switch newValue {
                case .category:
                    onCategorySelectionTap?(selectedCategory)
                default :
                    onFilterTypeTap?(newValue)
            }
        }
        .onChange(of: selectedCategory) { newValue in
            onCategorySelectionTap?(newValue)
        }
    }
}

// MARK: - Views
private extension FilterView {
    var filterTitle: some View {
        VStack {
            Text(Constants.filteredBy)
            Spacer()
        }
    }

    var chooseFilterOptionButton: some View {
        Button {
            withAnimation {
                isFilterSheetPresented.toggle()
            }
        } label: {
            VStack {
                if isFilterSheetPresented {
                    FilterOptionsView(
                        selectedFilter: $selectedFilter,
                        isPresented: $isFilterSheetPresented,
                        filterOptions: filterOptions)
                } else {
                    Text(selectedFilter.filterName)
                        .foregroundColor(.black)
                }
            }
            .frame(width: UIScreen.main.bounds.width / 2, height: isFilterSheetPresented ? filterHeight : 40)
            .overlay {
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 2.0)

            }
        }
    }

    @ViewBuilder
    var chooseCategoryButton: some View {
        if case .category = selectedFilter {
            Button {
                withAnimation {
                    isCategoryFilterSheetPresented.toggle()
                }
            } label: {
                VStack {
                    if isCategoryFilterSheetPresented {
                        FilterOptionsView(
                            selectedFilter: $selectedCategory,
                            isPresented: $isCategoryFilterSheetPresented,
                            filterOptions: availableCategories
                        )
                    } else {
                        Text("\(selectedCategory)")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 40, height: isCategoryFilterSheetPresented ? categoriesHeight : 40)
                .overlay {
                    RoundedRectangle(cornerRadius: 8.0)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 2.0)
                }
            }
        }
    }
}

extension FilterView {
    func onFilterTap(_ action: @escaping (FilterType) -> Void) -> Self {
        var view = self
        view.onFilterTypeTap = action
        return view
    }

    func onCategoryTap(_ action: @escaping (Int) -> Void) -> Self {
        var view = self
        view.onCategorySelectionTap = action
        return view
    }
}

// MARK: - Constants
private extension FilterView {
    enum Constants {
        static let filteredBy = "Filtered by: "
    }
}

#Preview {
    FilterView(availableCategories: [1, 2, 3, 4])
}
