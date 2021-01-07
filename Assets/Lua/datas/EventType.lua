EventType = class("EventType");

function EventType:ctor()
	self.card_out = 1000;
	self.deal_cards = 1001;
	self.select_card_handle = 1002;
	self.update_game_state = 1003;
	self.lander_sure = 1004;
	self.update_turn_seat = 1005;
end	