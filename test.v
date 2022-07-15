module main

import venven

pub fn fn_draw(receiver &venven.Game, args &venven.Game, sender &venven.Game) {

}

fn main() {
	mut game := venven.new("Test", 800, 400)

	game.sub("draw", fn_draw)

	game.run()
}