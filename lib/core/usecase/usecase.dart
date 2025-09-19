// Type: نوع خروجی که UseCase برمی‌گرداند (مثلا List<Task>)
// Params: پارامترهای ورودی که UseCase دریافت می‌کند (مثلا یک شیء Task)
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}
