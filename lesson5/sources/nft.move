module lesson5::discount_coupon {
    struct DiscountCoupon has key {
        id: UID,
        owner: address,
        discount: u8,
        expiration: u64,
    }

    /// Lấy thông tin của người sở hữu
    public fun owner(coupon: &DiscountCoupon): address {
        coupon.owner
    }

    /// Lấy thông tin discount của coupon
    public fun discount(coupon: &DiscountCoupon): u8 {
        coupon.discount
    }

    // Hoàn thiện function để mint 1 coupon và transfer coupon này cho một người nhận recipient
    public entry fun mint_and_topup(discount :u8 ,expiration : u64 ,recipient :address , ctx :&mut TxContext) {
        let sender = tx_context::sender(ctx);
        let coupon=Coupon{
            id: object::new(ctx),
            owner: sender,
            discount,
            experience,
        };
                transfer::transfer(coupon,recipient);
    }

    // hoàn thiện function để có thể transfer coupon cho 1 người khác
    public entry fun transfer_coupon(coupon: DiscountCoupon, recipient: address) {
        transfer::transfer(coupon, recipient);
    }

    // Hoàn thiện function đê huỷ, xoá đi coupon.
    public fun burn(nft: DiscountCoupon): bool {
        let nft{id, title:_ , description:_ , url:_ } = DiscountCoupon;
        object::delete(id);
    }

    // Hoàn thiện function để người dùng sử dụng, sau đó sẽ xoá đi cái coupon
    public entry fun scan(nft: &DiscountCoupon) : {
        
        // ....check information
        //get coupon 
        burn(nft);
    }
}
