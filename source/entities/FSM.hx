package entities;

class FSM
{
	public var activeState:Float->Void;

	public function new(initState:Float->Void)
	{
		activeState = initState;
	}

	public function update(elapsed:Float)
	{
		activeState(elapsed);
	}
}
