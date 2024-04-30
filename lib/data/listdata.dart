import 'package:vault_testing/data/1.dart';

List<Money> geter() {
  Money upwork = Money();
  upwork.name = 'upwork';
  upwork.fee = '650';
  upwork.time = 'today';
  upwork.image = 'up.png';
  upwork.buy = false;
  Money starbucks = Money();
  starbucks.buy = true;
  starbucks.fee = '15';
  starbucks.image = 'Star.jpg';
  starbucks.name = 'starbucks';
  starbucks.time = 'today';
  Money transfer = Money();
  transfer.buy = true;
  transfer.fee = '100';
  transfer.image = 'cre.png';
  transfer.name = 'transfer for sam';
  transfer.time = 'jan 30,2022';
  return [upwork, starbucks, transfer, upwork, starbucks, transfer];
}
