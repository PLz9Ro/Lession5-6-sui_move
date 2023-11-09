module lesson5::discount_coupon {
    struct DiscountCoupon has key {
        id: UID,
        owner: address,
        discount: u8,
        expiration: u64,
    }

    /// Lấy thông tin của người sở hữu
    public fun owner(coupon: &DiscountCoupon): address {}

    /// Lấy thông tin discount của coupon
    public fun discount(coupon: &DiscountCoupon): u8 {}

    // Hoàn thiện function để mint 1 coupon và transfer coupon này cho một người nhận recipient
    public entry fun mint_and_topup(
        coin: coin::Coin<SUI>,
        discount: u8,
        expiration: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {}

    // hoàn thiện function để có thể transfer coupon cho 1 người khác
    public entry fun transfer_coupon(coupon: DiscountCoupon, recipient: address) {}

    // Hoàn thiện function đê huỷ, xoá đi coupon.
    public fun burn(nft: DiscountCoupon): bool {}

    // Hoàn thiện function để người dùng sử dụng, sau đó sẽ xoá đi cái coupon
    public entry fun scan(nft: DiscountCoupon) {
        // ....check information
        burn(nft);
    }
}
