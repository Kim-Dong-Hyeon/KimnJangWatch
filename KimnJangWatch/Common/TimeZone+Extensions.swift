//
//  File.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/17/24.
//

import Foundation

extension String {
  func getCityName() -> String {
    return String(self.split(separator: ",").first!)
  }
}

extension TimeZone {
  static func getEngKor() -> [TimeZoneID] {
    return [
      TimeZoneID(eng: "Africa/Cairo", kor: "카이로, 이집트"),
      TimeZoneID(eng: "Africa/Casablanca", kor: "카사블랑카, 모로코"),
      TimeZoneID(eng: "Africa/Johannesburg", kor: "요하네스버그, 남아프리카 공화국"),
      TimeZoneID(eng: "Africa/Lagos", kor: "라고스, 나이지리아"),
      TimeZoneID(eng: "Africa/Nairobi", kor: "나이로비, 케냐"),
      TimeZoneID(eng: "America/Argentina/Buenos_Aires", kor: "부에노스아이레스, 아르헨티나"),
      TimeZoneID(eng: "America/Bogota", kor: "보고타, 콜롬비아"),
      TimeZoneID(eng: "America/Caracas", kor: "카라카스, 베네수엘라"),
      TimeZoneID(eng: "America/Chicago", kor: "시카고, 미국"),
      TimeZoneID(eng: "America/Denver", kor: "덴버, 미국"),
      TimeZoneID(eng: "America/Guatemala", kor: "과테말라시티, 과테말라"),
      TimeZoneID(eng: "America/Halifax", kor: "할리팩스, 캐나다"),
      TimeZoneID(eng: "America/Los_Angeles", kor: "로스앤젤레스, 미국"),
      TimeZoneID(eng: "America/Mexico_City", kor: "멕시코시티, 멕시코"),
      TimeZoneID(eng: "America/New_York", kor: "뉴욕, 미국"),
      TimeZoneID(eng: "America/Santiago", kor: "산티아고, 칠레"),
      TimeZoneID(eng: "America/Sao_Paulo", kor: "상파울루, 브라질"),
      TimeZoneID(eng: "Asia/Baghdad", kor: "바그다드, 이라크"),
      TimeZoneID(eng: "Asia/Bangkok", kor: "방콕, 태국"),
      TimeZoneID(eng: "Asia/Beirut", kor: "베이루트, 레바논"),
      TimeZoneID(eng: "Asia/Colombo", kor: "콜롬보, 스리랑카"),
      TimeZoneID(eng: "Asia/Dubai", kor: "두바이, 아랍에미리트"),
      TimeZoneID(eng: "Asia/Hong_Kong", kor: "홍콩, 홍콩"),
      TimeZoneID(eng: "Asia/Jakarta", kor: "자카르타, 인도네시아"),
      TimeZoneID(eng: "Asia/Kabul", kor: "카불, 아프가니스탄"),
      TimeZoneID(eng: "Asia/Karachi", kor: "카라치, 파키스탄"),
      TimeZoneID(eng: "Asia/Kolkata", kor: "콜카타, 인도"),
      TimeZoneID(eng: "Asia/Kuala_Lumpur", kor: "쿠알라룸푸르, 말레이시아"),
      TimeZoneID(eng: "Asia/Manila", kor: "마닐라, 필리핀"),
      TimeZoneID(eng: "Asia/Seoul", kor: "서울, 대한민국"),
      TimeZoneID(eng: "Asia/Shanghai", kor: "상하이, 중국"),
      TimeZoneID(eng: "Asia/Singapore", kor: "싱가포르, 싱가포르"),
      TimeZoneID(eng: "Asia/Taipei", kor: "타이베이, 대만"),
      TimeZoneID(eng: "Asia/Tehran", kor: "테헤란, 이란"),
      TimeZoneID(eng: "Asia/Tokyo", kor: "도쿄, 일본"),
      TimeZoneID(eng: "Asia/Ulaanbaatar", kor: "울란바토르, 몽골"),
      TimeZoneID(eng: "Asia/Vladivostok", kor: "블라디보스토크, 러시아"),
      TimeZoneID(eng: "Australia/Adelaide", kor: "애들레이드, 호주"),
      TimeZoneID(eng: "Australia/Brisbane", kor: "브리즈번, 호주"),
      TimeZoneID(eng: "Australia/Darwin", kor: "다윈, 호주"),
      TimeZoneID(eng: "Australia/Melbourne", kor: "멜버른, 호주"),
      TimeZoneID(eng: "Australia/Perth", kor: "퍼스, 호주"),
      TimeZoneID(eng: "Australia/Sydney", kor: "시드니, 호주"),
      TimeZoneID(eng: "Europe/Amsterdam", kor: "암스테르담, 네덜란드"),
      TimeZoneID(eng: "Europe/Athens", kor: "아테네, 그리스"),
      TimeZoneID(eng: "Europe/Belgrade", kor: "베오그라드, 세르비아"),
      TimeZoneID(eng: "Europe/Berlin", kor: "베를린, 독일"),
      TimeZoneID(eng: "Europe/Brussels", kor: "브뤼셀, 벨기에"),
      TimeZoneID(eng: "Europe/Budapest", kor: "부다페스트, 헝가리"),
      TimeZoneID(eng: "Europe/Copenhagen", kor: "코펜하겐, 덴마크"),
      TimeZoneID(eng: "Europe/Dublin", kor: "더블린, 아일랜드"),
      TimeZoneID(eng: "Europe/Helsinki", kor: "헬싱키, 핀란드"),
      TimeZoneID(eng: "Europe/Istanbul", kor: "이스탄불, 터키"),
      TimeZoneID(eng: "Europe/Lisbon", kor: "리스본, 포르투갈"),
      TimeZoneID(eng: "Europe/London", kor: "런던, 영국"),
      TimeZoneID(eng: "Europe/Madrid", kor: "마드리드, 스페인"),
      TimeZoneID(eng: "Europe/Moscow", kor: "모스크바, 러시아"),
      TimeZoneID(eng: "Europe/Paris", kor: "파리, 프랑스"),
      TimeZoneID(eng: "Europe/Prague", kor: "프라하, 체코"),
      TimeZoneID(eng: "Europe/Rome", kor: "로마, 이탈리아"),
      TimeZoneID(eng: "Europe/Stockholm", kor: "스톡홀름, 스웨덴"),
      TimeZoneID(eng: "Europe/Vienna", kor: "빈, 오스트리아"),
      TimeZoneID(eng: "Europe/Warsaw", kor: "바르샤바, 폴란드"),
      TimeZoneID(eng: "Pacific/Auckland", kor: "오클랜드, 뉴질랜드"),
      TimeZoneID(eng: "Pacific/Fiji", kor: "수바, 피지"),
      TimeZoneID(eng: "Pacific/Honolulu", kor: "호놀룰루, 미국"),
      TimeZoneID(eng: "Pacific/Tahiti", kor: "타히티, 프랑스령 폴리네시아")
    ]
  }
}
