
class TestData {

  List<Data> getPoints() {
      List<Data> data = new List<Data>();

      Data d1 = new Data();
      d1._one = "40.737102";
      d1._two = "-73.990318";
      data.add(d1);

      Data d2 = new Data();
      d2._one = "40.63623";
      d2._two = "-73.980318";
      data.add(d2);

      return data;

  }

}

class Data {

  String _one;
  String _two;

}