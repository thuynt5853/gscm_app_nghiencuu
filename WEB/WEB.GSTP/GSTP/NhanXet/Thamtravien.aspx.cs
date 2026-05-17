using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.NhanXet
{
    public partial class Thamtravien : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                txtYKien.Text = "";
                //"Bị cáo Trầm Bê (nguyên Phó Chủ tịch Thường trực HĐQT Sacombank) và Phan Huy Khang (nguyên Tổng Giám đốc Ngân hàng TMCP Sài Gòn Thương Tín) nói rằng cho Phạm Công Danh (nguyên Chủ tịch HĐQT Ngân hàng Xây dựng- VNCB, kiêm Tổng Giám đốc Tập đoàn Thiên Thanh) vay 1.800 tỉ đống nhưng chỉ có ông Bê và Danh bị truy tố, xét xử là không công bằng. Ông Bê không phục cáo trạng của VKS nên đề nghị xem xét."
                //            + "\r\n" +
                //            "Tại tòa, nhóm các bị cáo tại Ngân hàng BIDV nói rằng chỉ là vô ý nên truy tố không đúng. Cần làm rõ vấn đề này. Có ý kiến cho rằng hành vi của ông Danh là chiếm đoạt tiền của ngân hàng, dùng tiền chi cho nhiều mục đích.Cần điều tra có chiếm đoạt hay không, thời điểm và tiền chiếm đoạt dùng việc gì."
                //            + 
                //            "VKS đề nghị thu 6.126 tỉ đồng từ 3 ngân hàng; HĐXX xét thấy cần làm rõ số tiền thu từ 3 ngân hàng này là vật chứng của hành vi cố ý làm trái nào của ông Danh để xác định vật chứng làm căn cứ thu hồi.";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {

        }
    }
}