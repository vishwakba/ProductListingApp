import Foundation
@testable import AppCore

// MARK: - Sample API Response JSON

/// This is the expected API response format from https://dummyjson.com/products?limit=10&skip=0
let sampleProductJSON = """
{
  "products": [
    {
      "id": 1,
      "title": "Essence Mascara Lash Princess",
      "description": "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects.",
      "category": "beauty",
      "price": 9.99,
      "discountPercentage": 10.48,
      "rating": 2.56,
      "stock": 99,
      "tags": ["beauty", "mascara"],
      "brand": "Essence",
      "sku": "BEA-ESS-ESS-001",
      "weight": 4,
      "dimensions": { "width": 15.14, "height": 13.08, "depth": 22.99 },
      "warrantyInformation": "1 week warranty",
      "shippingInformation": "Ships in 3-5 business days",
      "availabilityStatus": "In Stock",
      "reviews": [
        {
          "rating": 3,
          "comment": "Would not recommend!",
          "date": "2025-04-30T09:41:02.053Z",
          "reviewerName": "Eleanor Collins",
          "reviewerEmail": "eleanor.collins@x.dummyjson.com"
        }
      ],
      "returnPolicy": "No return policy",
      "minimumOrderQuantity": 48,
      "meta": {
        "createdAt": "2025-04-30T09:41:02.053Z",
        "updatedAt": "2025-04-30T09:41:02.053Z",
        "barcode": "5784719087687",
        "qrCode": "https://cdn.dummyjson.com/public/qr-code.png"
      },
      "images": ["https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp"],
      "thumbnail": "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"
    },
    {
      "id": 2,
      "title": "Eyeshadow Palette with Mirror",
      "description": "The Eyeshadow Palette with Mirror offers a versatile range of eyeshadow shades.",
      "category": "beauty",
      "price": 19.99,
      "discountPercentage": 5.5,
      "rating": 4.12,
      "stock": 5,
      "tags": ["beauty", "eyeshadow"],
      "brand": "Glamour Beauty",
      "sku": "BEA-GLA-EYE-001",
      "weight": 3,
      "dimensions": { "width": 12.0, "height": 8.0, "depth": 2.0 },
      "warrantyInformation": "1 month warranty",
      "shippingInformation": "Ships in 1-2 business days",
      "availabilityStatus": "Low Stock",
      "reviews": [
        {
          "rating": 5,
          "comment": "Excellent quality!",
          "date": "2025-04-30T09:41:02.053Z",
          "reviewerName": "Liam Garcia",
          "reviewerEmail": "liam.garcia@x.dummyjson.com"
        }
      ],
      "returnPolicy": "30 days return policy",
      "minimumOrderQuantity": 10,
      "meta": {
        "createdAt": "2025-04-30T09:41:02.053Z",
        "updatedAt": "2025-04-30T09:41:02.053Z",
        "barcode": "1234567890123",
        "qrCode": "https://cdn.dummyjson.com/public/qr-code.png"
      },
      "images": ["https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/1.webp"],
      "thumbnail": "https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/thumbnail.webp"
    }
  ],
  "total": 194,
  "skip": 0,
  "limit": 10
}
""".data(using: .utf8)!

let sampleEmptyResponseJSON = """
{
  "products": [],
  "total": 0,
  "skip": 0,
  "limit": 10
}
""".data(using: .utf8)!

// MARK: - Mock Extensions

extension Product {
    static let mock = Product(
        availabilityStatus: "In Stock",
        brand: "Essence",
        category: "beauty",
        description: "A popular mascara known for its volumizing effects.",
        dimensions: Dimensions(depth: 22.99, height: 13.08, width: 15.14),
        discountPercentage: 10.48,
        id: 1,
        images: ["https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp"],
        meta: ProductMeta(
            barcode: "5784719087687",
            createdAt: "2025-04-30T09:41:02.053Z",
            qrCode: "https://cdn.dummyjson.com/public/qr-code.png",
            updatedAt: "2025-04-30T09:41:02.053Z"
        ),
        minimumOrderQuantity: 48,
        price: 9.99,
        rating: 2.56,
        returnPolicy: "No return policy",
        reviews: [Review.mock],
        shippingInformation: "Ships in 3-5 business days",
        sku: "BEA-ESS-ESS-001",
        stock: 99,
        tags: ["beauty", "mascara"],
        thumbnail: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp",
        title: "Essence Mascara Lash Princess",
        warrantyInformation: "1 week warranty",
        weight: 4
    )

    static let mockSecond = Product(
        availabilityStatus: "Low Stock",
        brand: "Glamour Beauty",
        category: "beauty",
        description: "The Eyeshadow Palette with Mirror offers a versatile range.",
        dimensions: Dimensions(depth: 2.0, height: 8.0, width: 12.0),
        discountPercentage: 5.5,
        id: 2,
        images: ["https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/1.webp"],
        meta: ProductMeta(
            barcode: "1234567890123",
            createdAt: "2025-04-30T09:41:02.053Z",
            qrCode: "https://cdn.dummyjson.com/public/qr-code.png",
            updatedAt: "2025-04-30T09:41:02.053Z"
        ),
        minimumOrderQuantity: 10,
        price: 19.99,
        rating: 4.12,
        returnPolicy: "30 days return policy",
        reviews: [],
        shippingInformation: "Ships in 1-2 business days",
        sku: "BEA-GLA-EYE-001",
        stock: 5,
        tags: ["beauty", "eyeshadow"],
        thumbnail: "https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/thumbnail.webp",
        title: "Eyeshadow Palette with Mirror",
        warrantyInformation: "1 month warranty",
        weight: 3
    )
}

extension Review {
    static let mock = Review(
        comment: "Would not recommend!",
        date: "2025-04-30T09:41:02.053Z",
        rating: 3,
        reviewerEmail: "eleanor.collins@x.dummyjson.com",
        reviewerName: "Eleanor Collins"
    )
}

extension ProductResponse {
    static let mock = ProductResponse(
        limit: 10,
        products: [Product.mock, Product.mockSecond],
        skip: 0,
        total: 194
    )

    static let mockEmpty = ProductResponse(
        limit: 10,
        products: [],
        skip: 0,
        total: 0
    )

    static let mockLastPage = ProductResponse(
        limit: 10,
        products: [Product.mock],
        skip: 190,
        total: 194
    )
}
