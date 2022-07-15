module venven

import eventbus
import sokol
import sokol.sapp
import sokol.gfx
import sokol.sgl

const (
    eb = eventbus.new()
)

pub struct Game {
	pub mut:
	title string
	width i16
	height i16
	sub eventbus.Subscriber = eb.subscriber
}

pub fn new(title string, width i16, height i16) Game {
	tm := Game{
		title: title
		width: width
		height: height
	}
	return tm
}

pub fn (mut g Game) sub(name string, call eventbus.EventHandlerFn) {
	g.sub.subscribe(name, call)
}

struct AppState {
	pass_action gfx.PassAction
	game Game
}

const (
	used_import = sokol.used_import
)

pub fn (mut g Game) run() {
	eb.publish('before_init', g, g)
	state := &AppState{
		pass_action: gfx.create_clear_pass(0.1, 0.1, 0.1, 1.0)
		game: g
	}
	title := g.title
	desc := sapp.Desc{
		width: g.width
		height: g.height
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
		window_title: title.str
		html5_canvas_name: title.str
	}
	sapp.run(&desc)
	eb.publish('after', g, g)
}

fn init(user_data voidptr) {
	desc := sapp.create_desc()
	state := &AppState(user_data)
	eb.publish('init', state.game, state.game)
	gfx.setup(&desc)
	sgl_desc := sgl.Desc{}
	sgl.setup(&sgl_desc)
}

fn frame(user_data voidptr) {
	state := &AppState(user_data)


	eb.publish('frame', state.game, state.game)

	gfx.begin_default_pass(&state.pass_action, sapp.width(), sapp.height())
	sgl.draw()
	gfx.end_pass()
	gfx.commit()
}