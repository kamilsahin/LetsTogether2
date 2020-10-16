import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/core/services/member_service.dart';

main(List<String> args) {
  test("SaveMember", () async {
    MemberService memberService = new  MemberService();
    Member member = new Member();
    member.name = 'name';
    member.surname = 'surname';
    member.birthday = new DateFormat('dd-MM-yyyy').parseStrict("12-08-2018");
    member.gender = 1;
    member.phoneNumber = 'phoneNumber';
    member.phoneNumber2 = 'phoneNumber2';
    member.disctrict = 'disctrict';
    member.city = 'city';
    member.country = 'country';
    member.imageUrl = 'imageUrl';
    member.userId = 'userId';
    member.about = 'about';
    member.hobies = 'hobies';
    member.instagram = 'instagram';
    member.twitter = 'twitter';
    member.facebook = 'facebook';
    member.website = 'website';

    memberService.saveMember(member);

    Member newMember =  await memberService.getMemberByMemberId(member.key);
   
    expect(member.name, newMember.name);
    expect(member.surname, newMember.surname);

  });


}