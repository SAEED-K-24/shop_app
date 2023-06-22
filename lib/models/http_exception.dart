class HttpException implements Exception
{
 final String messege ;
 HttpException(this.messege);

 @override
  String toString() {
    // TODO: implement toString
   return messege ;
    //return super.toString();
  }
}