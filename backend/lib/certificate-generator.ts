// Helper functions for Gujarati Dates
function getGujaratiNumberWord(n: number): string {
  const words = ["", "એક", "બે", "ત્રણ", "ચાર", "પાંચ", "છ", "સાત", "આઠ", "નવ", "દસ", "અગિયાર", "બાર", "તેર", "ચૌદ", "પંદર", "સોળ", "સત્તર", "અઢાર", "ઓગણીસ", "વીસ", "એકવીસ", "બાવીસ", "તેવીસ", "ચોવીસ", "પચ્ચીસ", "છવીસ", "સત્તાવીસ", "અઠ્ઠાવીસ", "ઓગણત્રીસ", "ત્રીસ"];
  if (n <= 30) return words[n];
  return n.toString(); // Fallback if > 30, though for dates usually max 31.
}

export function dateToGujaratiWords(dateStr: string | Date | null | undefined): string {
  if (!dateStr) return "";
  const d = new Date(dateStr);
  if (isNaN(d.getTime())) return "";

  const day = d.getDate(); // 1-31
  const month = d.getMonth(); // 0-11
  const year = d.getFullYear();

  const daysWords = ["", "પહેલી", "બીજી", "ત્રીજી", "ચોથી", "પાંચમી", "છઠ્ઠી", "સાતમી", "આઠમી", "નવમી", "દસમી", "અગિયારમી", "બારમી", "તેરમી", "ચૌદમી", "પંદરમી", "સોળમી", "સત્તરમી", "અઢારમી", "ઓગણીસમી", "વીસમી", "એકવીસમી", "બાવીસમી", "તેવીસમી", "ચોવીસમી", "પચ્ચીસમી", "છવીસમી", "સત્તાવીસમી", "અઠ્ઠાવીસમી", "ઓગણત્રીસમી", "ત્રીસમી", "એકત્રીસમી"];
  const monthsWords = ["જાન્યુઆરી", "ફેબ્રુઆરી", "માર્ચ", "એપ્રિલ", "મે", "જૂન", "જુલાઈ", "ઓગસ્ટ", "સપ્ટેમ્બર", "ઓક્ટોબર", "નવેમ્બર", "ડિસેમ્બર"];

  // Year Conversion Logic
  // var yearStr = year.toString();
  const yearRemainder = year % 100;
  const yearWord = "બે હજાર " + (year === 2000 ? "" : getGujaratiNumberWord(yearRemainder));

  return (daysWords[day] || day.toString()) + " " + (monthsWords[month] || "") + " " + yearWord.trim();
}

export function formatDateGujarati(dateStr: string | Date | null | undefined): string {
  if (!dateStr) return "";
  const d = new Date(dateStr);
  if (isNaN(d.getTime())) return "";

  const dd = ("0" + d.getDate()).slice(-2);
  const mm = ("0" + (d.getMonth() + 1)).slice(-2);
  const yyyy = d.getFullYear();
  return `${dd}-${mm}-${yyyy}`;
}

export function toGujaratiNumbers(n: string | number): string {
  const map: { [key: string]: string } = {
    '0': '૦', '1': '૧', '2': '૨', '3': '૩', '4': '૪',
    '5': '૫', '6': '૬', '7': '૭', '8': '૮', '9': '૯'
  };
  return n.toString().split('').map(char => map[char] || char).join('');
}


// --- Template Generators ---

export function getBonafideHtml(data: any): string {
  // Extract and Process Data
  const fullName = data.fullName || '';
  const std = data.standard === '0' || data.standard === 0 ? 'Balwatika' : data.standard;
  const status = 'અભ્યાસ કરે છે';
  const dob = data.dob;
  const formattedDob = formatDateGujarati(dob);
  const dobWords = dateToGujaratiWords(dob);
  const grNo = toGujaratiNumbers(data.grNo || '');
  const today = formatDateGujarati(new Date());

  // HTML from User
  return `
  <html>
    <head>
      <meta charset="UTF-8">
      <link href="https://fonts.googleapis.com/css2?family=Mukta+Vaani:wght@400;700&display=swap" rel="stylesheet">
    <style>
        @page { size: A4 portrait; margin: 10mm; }
        body { font-family: 'Mukta Vaani', sans-serif; padding: 0; line-height: 2.5; color: #000; font-size: 18px; margin: 0; }
        .container { border: 3px double black; padding: 25px; height: 97vh; box-sizing: border-box; }
        .header { text-align: center; font-size: 26px; font-weight: bold; margin-bottom: 5px; }
        .subheader { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .subheader td { font-size: 18px; font-weight: bold; padding: 5px 0; }
        .title-container { position: relative; text-align: center; margin-top: 30px; margin-bottom: 60px; }
        .main-title { font-size: 24px; font-weight: bold; border-bottom: 2px solid black; display: inline-block; padding-bottom: 2px; }
        .photo-box { position: absolute; right: 0; top: -10px; width: 110px; height: 130px; border: 1.5px solid black; text-align: center; line-height: 110px; font-size: 14px; }
        .content { font-size: 20px; text-align: justify; margin-top: 40px; }
        .line { border-bottom: 1px dotted black; font-weight: bold; padding: 0 10px; display: inline-block; text-align: center; min-width: 50px;}
        .footer-table { width: 100%; margin-top: 80px; }
        .footer-table td { font-size: 18px; font-weight: bold; text-align: center; vertical-align: bottom; }
        .sign-area { margin-top: 10px; border-top: 1.5px solid black; width: 160px; display: inline-block; }
      </style>
    </head>
    <body>
      <div class="container">
      <div class="header">નગર પ્રાથમિક શિક્ષણ સમિતિ સંચાલિત</div>
      
      <table class="subheader">
        <tr>
          <td width="70%">શાળાનું નામ : <span class="line" style="min-width: 250px;">આદિનાથનગર પ્રાથમિક શાળા</span></td>
          <td width="30%" style="text-align: right;">તાલુકો : <span class="line" style="min-width: 80px;">AMC</span></td>
        </tr>
      </table>

      <br>
      <div class="title-container">
        <div class="main-title">બોનાફાઈડ સર્ટી / જન્મ તારીખનો દાખલો</div>
        <div class="photo-box">ફોટો</div>
      </div>

      <br>
      <div class="content">
        આથી પ્રમાણપત્ર આપવામાં આવે છે કે શ્રી <span class="line">${fullName}</span> 
        અત્રેની પ્રાથમિક શાળામાં ધો. <span class="line">${std}</span> માં <span class="line">${status}</span>. 
        જેમની જન્મ તારીખ <span class="line">${formattedDob}</span> શબ્દોમાં <span class="line">${dobWords}</span> 
        છે. જે શાળાના વયપત્રક નંબર <span class="line">${grNo}</span> પરથી ખરાઈ કરી લખી આપવામાં આવે છે.
      </div>
      <br>
      <table class="footer-table">
        <tr>
          <td width="33%" style="text-align: left;">અમદાવાદ<br>તારીખ : <span style="min-width: 100px;">${today}</span></td>
          <td width="33%">વર્ગ શિક્ષકની સહી<br><br><br><div class="sign-area"></div></td>
          <td width="33%" style="text-align: right;">મુખ્ય શિક્ષકની સહી<br><br><br><div class="sign-area"></div></td>
        </tr>
      </table>
      </div>
    </body>
  </html>
  `;
}

export function getValiFormHtml(data: any): string {
  const fullName = data.fullName || '';
  const parts = fullName.toString().trim().split(' ');
  // Simple heuristic split if individual fields not present
  const name = data.firstName || (parts.length > 0 ? parts[0] : '');
  const fname = data.fatherName || (parts.length > 1 ? parts[1] : '');
  const surname = parts.length > 2 ? parts[parts.length - 1] : '';

  const engName = (data.engName || fullName).toUpperCase();
  const fEdu = data.fatherEdu || '';
  const mName = data.motherName || '';
  const mEdu = data.motherEdu || '';
  const fOcc = data.fatherOcc || '';
  const mOcc = data.motherOcc || '';
  const caste = data.caste || '';
  const gender = data.gender === 'Boy' ? 'કુમાર' : 'કન્યા';

  const dob = data.dob;
  const formattedDob = formatDateGujarati(dob);
  const dobWords = dateToGujaratiWords(dob);
  const bPlace = data.birthPlace || '';
  const address = data.address || '';
  const mobile = data.mobile || '';
  const mTongue = 'ગુજરાતી';
  const doc = 'જન્મનો દાખલો';
  const formNo = 'Vali-' + (data.id || 'NEW');
  const today = formatDateGujarati(new Date());
  const teacherName = "વર્ગ શિક્ષક";

  // Logo - Ensure this URL is accessible or use base64
  const logoSrc = "https://www.amcschoolboard.org/wp-content/uploads/2025/02/download-removebg-preview.png";

  return `
  <html>
    <head>
      <meta charset="UTF-8">
      <link href="https://fonts.googleapis.com/css2?family=Mukta+Vaani:wght@400;700&display=swap" rel="stylesheet">
      <style>
        @page { size: A4 portrait; margin: 5mm; }
        body { font-family: 'Mukta Vaani', sans-serif; margin: 0; padding: 4mm; font-size: 13px; }
        .main-table { width: 100%; border-collapse: collapse; border: 1.5px solid black; }
        .main-table td { border: 1px solid black; padding: 3px 6px; }
        .bg-label { font-weight: bold; width: 30%; }
        .center { text-align: center; }
        .bold { font-weight: bold; }
        .left-bold { text-align: left; font-weight: bold; padding-left: 5px; }
        .left-align-bold { text-align: left; font-weight: bold; padding-left: 5px; vertical-align: middle; }
        .header-logo { width: 80px; }
        .photo-box { width: 100px; height: 120px; border: 1.2px solid black; text-align: center; vertical-align: middle; }
      </style>
    </head>
    <body>
      <table width="100%" style="margin-bottom: 5px;">
        <tr>
          <td width="15%"><img src="${logoSrc}" class="header-logo"></td>
          <td class="center">
            <div style="font-size: 20px; font-weight: bold;">નગર પ્રાથમિક શિક્ષણ સમિતિ, અમદાવાદ</div>
            <div style="font-size: 16px; font-weight: bold;">વાલી ફોર્મ</div>
            <div style="margin-top: 5px;">વાલી ફોર્મ નંબર : <span style="border: 1.5px solid black; padding: 2px 25px; font-weight: bold;">${formNo}</span></div>
          </td>
          <td width="15%" class="photo-box">ફોટો</td>
        </tr>
      </table>

      <table class="main-table">
        <tr>
          <td rowspan="2" class="center bold" width="4%">૧</td>
          <td rowspan="2" class="bg-label">વિદ્યાર્થીનું પૂરેપૂરું નામ :</td>
          <td class="center bold">ગુજરાતી</td>
          <td class="center bold">નામ: ${name}</td>
          <td class="center bold">પિતાનું નામ: ${fname}</td>
          <td class="center bold">અટક: ${surname}</td>
        </tr>
        <tr>
          <td class="center bold">અંગ્રેજી</td>
          <td colspan="3" class="center bold" style="text-transform: uppercase;">${engName}</td>
        </tr>
        <tr>
          <td rowspan="2" class="center bold">૨</td>
          <td class="bg-label">પિતાનું નામ</td>
          <td colspan="4">${fname}</td>
        </tr>
        <tr>
          <td class="bg-label">પિતાનો અભ્યાસ</td>
          <td colspan="4">${fEdu}</td>
        </tr>
        <tr>
          <td rowspan="2" class="center bold">૩</td>
          <td class="bg-label">માતાનું નામ</td>
          <td colspan="4">${mName}</td>
        </tr>
        <tr>
          <td class="bg-label">માતાનો અભ્યાસ</td>
          <td colspan="4">${mEdu}</td>
        </tr>
        <tr>
          <td rowspan="2" class="center bold">૪</td>
          <td class="bg-label">પિતાનો વ્યવસાય</td>
          <td colspan="4">${fOcc}</td>
        </tr>
        <tr>
          <td class="bg-label">માતાનો વ્યવસાય</td>
          <td colspan="4">${mOcc}</td>
        </tr>
        <tr><td class="center bold">૫</td><td class="bg-label">ધર્મ અને જ્ઞાતિ</td><td colspan="4">${caste}</td></tr>
        <tr><td class="center bold">૬</td><td class="bg-label">જાતિ (કુમાર / કન્યા)</td><td colspan="4">${gender}</td></tr>

        <tr>
          <td rowspan="2" class="center bold">૭</td>
          <td class="left-align-bold" rowspan="2">જન્મ તારીખ</td>
          <td class="center bold">આંકડામાં</td>
          <td colspan="3" class="left-bold">${formattedDob}</td>
        </tr>
        <tr>
          <td class="center bold">શબ્દોમાં</td>
          <td colspan="3" class="left-bold">${dobWords}</td>
        </tr>

        <tr><td class="center bold">૮</td><td class="bg-label">જન્મ સ્થળ</td><td colspan="4">${bPlace}</td></tr>

        <tr>
          <td rowspan="2" class="center bold">૯</td>
          <td class="bg-label">હાલનું રહેઠાણનું સરનામું</td>
          <td colspan="4">${address}</td>
        </tr>
        <tr>
          <td class="bg-label">મોબાઈલ નંબર</td>
          <td colspan="4">${mobile}</td>
        </tr>

        <tr><td class="center bold">૧૧</td><td class="bg-label">વિદ્યાર્થીની માતૃભાષા</td><td colspan="4">${mTongue}</td></tr>
        <tr><td class="center bold">૧૨</td><td class="bg-label">જન્મ તારીખ માટે કયો આધાર આપ્યો?</td><td colspan="4">${doc}</td></tr>
      </table>

      <table width="100%" style="margin-top: 10px;">
        <tr>
          <td width="15%">તારીખ: ${today}</td>
          <td width="25%">વાલીની સહી __________</td>
          <td width="40%" style="text-align: right;">
            શિક્ષકનું નામ: <b>${teacherName}</b> &nbsp;&nbsp;&nbsp;
            સહી: __________
          </td>
        </tr>
      </table>
      <br>

      <div style="border: 1px solid black; margin-top: 5px; padding: 5px;">
        <div class="center bold">શાળાના ઉપયોગ માટે</div>
        <p style="margin: 5px 0;">સામાન્ય વયપત્રક નંબર .................... તારીખ..................... ના રોજ દાખલ કર્યો.</p>
        <p style="margin: 5px 0;">શાળાનું નામ: <b>આદિનાથનગર પ્રાથમિક શાળા</b></p>
      </div>
      <br>
      <br>
      <br>
      
      <div style="text-align: right; margin-top: 15px; font-weight: bold;">
        આચાર્યના સહી / સિક્કો
      </div>
    </body>
  </html>
    `;
}
