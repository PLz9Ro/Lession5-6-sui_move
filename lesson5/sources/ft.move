// Hoàn thiện đoạn code để có thể publish được
module lesson5::FT_TOKEN {
    use sui::coin::{Self , CoinMetadata , TreasuryCap};
    use sui::url;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    use std::option;
    use std::string;
    

    struct  FT_TOKEN { }

    fun init(witness: FT_TOKEN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            witness,
        2,
        b"TOKEN$" ,
        b"FT_TOKEN$",
        b"Lession 5",
        option::some(url::new_unsafe_from_bytes(b"https://img.meta.com.vn/Data/image/2021/09/22/anh-meo-cute-trai-tim-20.jpg")),
        ctx
        ) ; 
        transfer::public_transfer(metadata, tx_context::sender(ctx));
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
    }

    // hoàn thiện function để có thể tạo ra 10_000 token cho mỗi lần mint, và mỗi owner của token mới có quyền mint
    public fun mint(_: &CoinMetadata<FT_TOKEN>, treasury_cap :&mut TreasuryCap<FT_TOKEN> , amount:u64 , recipient :address , ctx: &mut TxContext) {
        coin::mint_and_transfer (treasury_cap , amount , recipient ,ctx);
    }

    // Hoàn thiện function sau để user hoặc ai cũng có quyền tự đốt đi số token đang sở hữu
    public entry fun burn_token(treasury_cap: &mut TreasuryCap , coin Coin<FT_TOKEN>) {
        coin::burn(treasury_cap,coin);
    }

    // Hoàn thiện function để chuyển token từ người này sang người khác.
    public entry fun transfer_token(coin:CoinMetadata<FT_TOKEN> , recipient: address) {

        transfer::public_transfer(coin,recipient);
        event::emit(UpdateEvent{
            success:true,
            data:data,
        })  
        // sau đó khởi 1 Event, dùng để tạo 1 sự kiện khi function transfer được thực thi
    }

    // Hoàn thiện function để chia Token Object thành một object khác dùng cho việc transfer
    // gợi ý sử dụng coin:: framework
    public entry fun split_token() {

    }

    // Viết thêm function để token có thể update thông tin sau
    public entry fun update_name (coin: &mut CoinMetadata<FT_TOKEN> , treasury_cap: &mut TreasuryCap<FT_TOKEN> ,new_name: string::String){
        coin::update_name<FT_TOKEN>(treasury_cap,coin,new_name);
    }
    public entry fun update_description (coin: &mut CoinMetadata<FT_TOKEN> , treasury_cap: &mut TreasuryCap<FT_TOKEN> ,new_des: string::String){
        coin::update_description<TOKEN>(treasury_cap,coin,new_name);
    } 
    public entry fun update_symbol (coin: &mut CoinMetadata<FT_TOKEN> , treasury_cap: &mut TreasuryCap<FT_TOKEN> ,new_symbol: string::String){
        coin::update_symbol<TOKEN>(treasury_cap,coin,new_name);
    } 
    public entry fun update_ICON (coin: &mut CoinMetadata<FT_TOKEN> , treasury_cap: &mut TreasuryCap<FT_TOKEN> , new_Icon: string::String){
        coin::update_ICON<TOKEN>(treasury_cap,coin,new_name);
    }

    // sử dụng struct này để tạo event cho các function update bên trên.
    struct UpdateEvent {
        success: bool,
        data: String
    }

        // Viết các function để get dữ liệu từ token về để hiển thị
        public entry fun get_name<FT_TOKEN>(coin: &CoinMetadata<FT_TOKEN>): string::String {
            coin.name
            }
        public entry fun get_description<FT_TOKEN>(coin: &CoinMetadata<FT_TOKEN>): string::String {
                coin.description
            }
        public entry fun get_symbol<FT_TOKEN>(coin: &CoinMetadata<FT_TOKEN>): string::String {
                coin.symbol
            }
        public entry fun get_icon_url<FT_TOKEN>( coin: &CoinMetadata<FT_TOKEN>): Option<Url> {
        coin.icon_url
            }
            // các hàm get em lý từ git của sui về và làm theo ví dụ luôn ạ 

}
