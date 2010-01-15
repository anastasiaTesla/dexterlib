package {
	public function sendDexterEvent(...arg):*{
		return DexterEvent.SendEvent.apply(DexterEvent,arg);
	}
}