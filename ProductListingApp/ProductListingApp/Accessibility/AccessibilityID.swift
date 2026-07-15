import Foundation

enum AccessibilityID {

    // MARK: - Common

    enum Common {
        static let buttonBack = "common_button_back"
        static let buttonClose = "common_button_close"
        static let labelError = "common_label_error"
        static let viewEmpty = "common_view_empty"
        static let viewError = "common_view_error"
        static let viewLoading = "common_view_loading"
        static let viewToast = "common_view_toast"
    }

    // MARK: - Product Detail

    enum ProductDetail {
        static let buttonFavorite = "product_detail_button_favorite"
        static let imageGallery = "product_detail_image_gallery"
        static let infoAvailability = "product_detail_info_availability"
        static let infoBrand = "product_detail_info_brand"
        static let infoCategory = "product_detail_info_category"
        static let infoDimensions = "product_detail_info_dimensions"
        static let infoMinOrder = "product_detail_info_min_order"
        static let infoReturn = "product_detail_info_return"
        static let infoShipping = "product_detail_info_shipping"
        static let infoSku = "product_detail_info_sku"
        static let infoStock = "product_detail_info_stock"
        static let infoWarranty = "product_detail_info_warranty"
        static let infoWeight = "product_detail_info_weight"
        static let labelDescription = "product_detail_label_description"
        static let labelPrice = "product_detail_label_price"
        static let labelTitle = "product_detail_label_title"
        static let ratingView = "product_detail_rating"
        static let sectionReviews = "product_detail_section_reviews"
        static let viewContainer = "product_detail_view_container"

        static func reviewCard(_ index: Int) -> String {
            "product_detail_review_card_\(index)"
        }
    }

    // MARK: - Product List

    enum ProductList {
        static let buttonFilter = "product_list_button_filter"
        static let listProducts = "product_list_list_products"
        static let textfieldSearch = "product_list_textfield_search"
        static let viewContainer = "product_list_view_container"
        static let viewFilter = "product_list_view_filter"

        static func buttonFavorite(_ index: Int) -> String {
            "product_list_button_favorite_\(index)"
        }

        static func cellProduct(_ index: Int) -> String {
            "product_list_cell_product_\(index)"
        }
    }
}
