// hoàn thiện code để module có thể publish được
module lesson6::hero_game {

    use sui::object::{Self,UID ,ID};
    use sui::tx_context::{Self,TxContext};
    use sui::transfer;
    use sui::coin::{Self,Coin};
    use sui::sui::SUI;

    use std::string::{Self,String};
    use std::option::{Self,Option};

    // Điền thêm các ability phù hợp cho các object
    struct Hero has key , store{
        id: UID,
        name: String,
        hp: u64,
        experience: u64,
    }

    // Điền thêm các ability phù hợp cho các object
    struct Sword has key, store {
        id: UID,
        attack: u64,
        strenght: u64,
    }

    // Điền thêm các ability phù hợp cho các object
    struct Armor has key, store {
        id: UID,
        defense: u64,
    }

    // Điền thêm các ability phù hợp cho các object
    struct Monter has key, store {
        id: UID,
        hp: u64,
        strenght: u64,
    }

    struct GameInfo has key {
        id: UID,
        admin: address
    }
    struct GameAdmin has key ,store{
        id:UID,
        game_id:ID,
        heros:u64,
        monters:u64
    }

    // hoàn thiện function để khởi tạo 1 game mới
    fun init(ctx: &mut TxContext) {
        new_game(ctx);
    }

    // function để create các vật phẩm, nhân vật trong game.
    fun create_hero(game: &GameInfo ,name:String, sword: Sword,armor: Armor ,ctx :&mut TxContext) {
        Hero{
            id:object::new(ctx),
            name,
            hp:100,
            experience:0,
            sword:option::some(sword),
            armor:option::some(armor),
            game_id:get_name_id(game),
        }
    }
    fun create_sword(game: &GameInfo , payment:Coin<SUI> ,ctx:&mut TxContext):Sword {
        let value = coin::value(&payment);
        assert!(value >= 10 , ERROR);

        let attack =(value*2);
        let strenght = (value *3);

        transfer::public_transfer(payment,game.admin);
        Sword{
            id:object::new(ctx),
            attack,
            strenght,
            game_id: get_name_id(game) 
        };
    }
    fun create_armor(game: &GameInfo , payment:Coin<SUI> ,ctx:&mut TxContext):Armor {
        let value = coin::value(&payment);
        assert!(value >= 10 , ERROR);

        let defense =(value*2);
        transfer::public_transfer(payment,game.admin);
        Armor{
            id:object::new(ctx),
            defense,
            game_id: get_name_id(game)
        };
    }

    // function để create quái vật, chiến đấu với hero, chỉ admin mới có quyền sử dụng function này
    // Gợi ý: khởi tạo thêm 1 object admin.
    fun create_monter(admin: &GameAdmin , game: &GameInfo,hp:u64 ,strenght:u64,player:address ,ctx:&mut TxContext) {
        admin.monters =admin.monters+=1;
        transfer::transfer(Monter{
            id:object::new(ctx),
            hp,
            strenght,
            game_id:get_name_id(game),
        };
        transfer::transfer(monter,player));
    }

    // func để tăng điểm kinh nghiệm cho hero sau khi giết được quái vật
    fun level_up_hero(hero :&mut Hero, amount:u64) {
        hero.hp: + amount;
        hero.experience + amount;
    }
    fun level_up_sword(sword:&mut Sword,amount:u64) {
        sword.attack + amount;
        sword.strenght + amount;
    }
    fun level_up_armor(armor :&mut Armor , amount:u64) {
        armor.defense + amount;

    }

    // Tấn công, hoàn thiện function để hero và monter đánh nhau
    // gợi ý: kiểm tra số điểm hp và strength của hero và monter, lấy hp trừ đi số sức mạnh mỗi lần tấn công. HP của ai về 0 trước người đó thua
    public entry fun attack_monter() {
        let Monter {id: monter_id , monter_hp,game_id:_} = monter;
        let Hero_pow = hero_hp(hero);

        while(monter_hp> Hero_pow){
            monter_hp= monter_hp - Hero_pow;
            assert!(Hero_pow >= monter_hp ,MONTER_WON)
            hero_hp = hero_hp - monter_hp;
        };

        hero_hp=hero_hp;
        hero.exp = hero.exp + hero.hp;
        
        if(optin::is_some(&hero.sword)){
            level_up_sword(option::borrow_mut(&mut hero.sword),2)
        };

        event::emit(AttackerEvent{
            slayer:tx_context::sender(ctx),
            hero: object::uid_to_inner(&hero.id),
            monter: object::uid_to_inner(&monter_id),
            game_id:get_name_id(game)
        });
        object::delete(monter_id);
    }

}
