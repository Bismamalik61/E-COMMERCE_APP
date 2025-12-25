import '../models/product_model.dart';

class MockDataService {
  static List<Product> getProducts() {
    final tShirtImages = [
      'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1562157873-818bc0726f68?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1581655353564-df123a1eb820?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1576566588028-4147f3842f27?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1527719327859-c6ce80353573?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1583743814966-8936f5b7dc9a?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1554568212-3c1a486f6680?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1574180563860-167e27c6e5c7?q=80&w=800&auto=format&fit=crop',
    ];

    final pantImages = [
      'https://images.unsplash.com/photo-1624371414361-e6e9ea35655e?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1565084888206-ac2467d383ca?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1582554189441-171ef99484b3?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1517594422361-5eeb8ae271a8?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1560243563-062bff001d68?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1555689502-c4b22d76c56f?q=80&w=800&auto=format&fit=crop',
    ];

    final shoeImages = [
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1491553895911-0055eca6402d?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1560769629-975ec94e6a86?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1549298916-b41d501d3772?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1608231387042-66d1773070a5?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1512374382149-433a72b75d6d?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1514989940723-e8e51635b782?q=80&w=800&auto=format&fit=crop',
    ];

    final bagImages = [
      'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1591561954557-26941169b49e?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1614179924047-e1645535270c?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1575032895531-15822f5186ad?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1581605405669-fcdf81165afa?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1598532163257-ae3c6b2524b6?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1531933355659-4ae31951ca74?q=80&w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1524498250077-390f9e378fc0?q=80&w=800&auto=format&fit=crop',
    ];

    return [
      // T-shirts
      ...List.generate(10, (index) => Product(
        id: 'tshirt_${index + 1}',
        name: 'Premium T-shirt ${index + 1}',
        description: 'Comfortable and stylish cotton T-shirt, perfect for daily wear. Available in various colors.',
        price: 19.99 + (index * 2),
        imageUrl: tShirtImages[index],
        category: 'T-shirt',
        rating: 4.5 + (index % 5) / 10,
      )),
      // Pants
      ...List.generate(10, (index) => Product(
        id: 'pant_${index + 1}',
        name: 'Classic Pant ${index + 1}',
        description: 'Durable and well-fitted pants for both casual and formal occasions.',
        price: 39.99 + (index * 5),
        imageUrl: pantImages[index],
        category: 'Pant',
        rating: 4.2 + (index % 5) / 10,
      )),
      // Shoes
      ...List.generate(10, (index) => Product(
        id: 'shoes_${index + 1}',
        name: 'Sport Shoes ${index + 1}',
        description: 'Lightweight running shoes with excellent grip and comfort.',
        price: 59.99 + (index * 10),
        imageUrl: shoeImages[index],
        category: 'Shoes',
        rating: 4.6 + (index % 5) / 10,
      )),
      // Bags
      ...List.generate(10, (index) => Product(
        id: 'bag_${index + 1}',
        name: 'Stylish Bag ${index + 1}',
        description: 'Spacious and elegant bag for all your essentials.',
        price: 29.99 + (index * 8),
        imageUrl: bagImages[index],
        category: 'Bag',
        rating: 4.4 + (index % 5) / 10,
      )),
    ];
  }

  static List<String> getBannerImages() {
    return [
      'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=2000&auto=format&fit=crop', // Mega Sale
      'https://images.unsplash.com/photo-1607082350899-7e105aa886ae?q=80&w=2000&auto=format&fit=crop', // Special Offer
      'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?q=80&w=2000&auto=format&fit=crop', // Shopping Deals
    ];
  }
}
