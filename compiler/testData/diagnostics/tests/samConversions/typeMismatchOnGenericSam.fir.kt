fun interface MySam<T> {
    fun execute(p0: T)

    fun identity(sam: MySam<T>): MySam<T> = sam

    fun m(p1: T) {
        val y: MySam<T> = identity { it: String -> }
        y.execute(p1)
    }
}