using BL.GSTP.PCTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.PCA
{
    public partial class BaoCao : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
                LoadReport();
            
        }
        private void LoadReport()
        {
            try
            {
                PCANN_BL pca = new PCANN_BL();
                decimal vID = 0;
                if (Request["cid"] != null)
                {
                    vID = Convert.ToInt32(Request["cid"]);
                    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_TINH_ID]);                   
                    var result = pca.PCANN_BAOCAO(vID);
                    DataTable tbl_loaian = result.Tables[0];
                    DataTable tbl_anpc = result.Tables[1];

                    StringBuilder html = new StringBuilder();
                    string loai_an = "";
                    string giai_doan = "";
                    DateTime today = DateTime.Today;
                    foreach (DataRow row in tbl_loaian.Rows)
                    {
                        switch (row["MA_GIAI_DOAN"].ToString())
                        {
                            case "1":
                                giai_doan = "ĐƠN";
                                break;
                            case "2":
                                giai_doan = "SƠ THẨM";
                                break;
                            case "3":
                                giai_doan = "PHÚC THẨM";
                                break;                           
                            default:
                                giai_doan = "";
                                break;
                        }

                        switch (row["LOAI_AN"].ToString())
                        {
                            case "HS":
                                loai_an = "HÌNH SỰ";
                                break;
                            case "HN":
                                loai_an = "HÔN NHÂN";
                                break;
                            case "KT":
                                loai_an = "KINH TẾ";
                                break;
                            case "DS":
                                loai_an = "DÂN SỰ";
                                break;
                            case "HC":
                                loai_an = "HÀNH CHÍNH";
                                break;
                            case "LD":
                                loai_an = "LAO ĐỘNG";
                                break;
                            case "PS":
                                loai_an = "PHÁ SẢN";
                                break;
                            case "XLHC":
                                loai_an = "XỬ LÝ HÀNH CHÍNH";
                                break;
                            default:
                                loai_an = "";
                                break;
                        }
                        html.Append(" <table class='bkg-tranfer' cellpadding='20' cellspacing='0' border='0' style='width:100%'>");
                        html.Append("<tr>");
                        html.Append("<td style = 'width:35%; text-align:center'>");
                        html.Append("<p style ='padding:0; margin:0;'><b>" + row["TEN"]+ "</b></p>");
                        html.Append("<p style = 'padding:0; margin:0;'><b> PHÒNG ......</b></p>");
                        //html.Append("<p style = 'padding:0; margin:0;border:0;  width:135px; border-top:1px solid #000000;'></p>");
                        html.Append("<hr style = 'padding:0; margin:0 auto; height:0; border:0; border-top:1px solid #000000; width:135px; position:relative; left:-3px'/>");
                        html.Append("</td>");
                        html.Append("<td style = 'width:65%; text-align:center;'>");
                        html.Append("<p style = 'padding:0; margin:0;'><b> CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM </b></p>");
                        html.Append("<b> Độc lập - Tự do - Hạnh phúc </b>");
                        html.Append("<hr style = 'padding:0; margin:0 auto; height:0; border:0; border-top:1px solid #000000; width:150px; position:relative; left:-2px'/></br>");
                        html.Append("Hà Nội, ngày "+ today.Day + " tháng "+ today.Month + " năm" + today.Year);
                        html.Append("</td>");
                        html.Append("</tr>");
                        html.Append("<tr>");
                        html.Append("<td colspan = '2' style = 'width:100%; text-align:center; padding:10px 0 0 0; margin:0 auto'>");
                        html.Append("<b style = 'font-size:16px;'> DANH SÁCH KẾT QUẢ PHÂN CÔNG THẨM PHÁN GIẢI QUYẾT CÁC VỤ ÁN " + loai_an +" "+ giai_doan + " TRÌNH CHÁNH ÁN PHÊ DUYỆT</b><br/>");
                        html.Append("<p style = 'line-height:2; font-size:14px; margin:0;'>");
                        html.Append("(Phần mềm thực hiện phân công ngẫu nhiên lần thứ… ngày " + row["NGAY_PHAN_CONG"] +")</p><br/>");
                        html.Append("</td>");
                        html.Append("</tr>");

                        html.Append("<tr>");
                        html.Append("<td colspan = '2' style = 'width:100%; text-align:left; padding:10px 0 0 10px; margin:0 auto'><b>Tổng số vụ: "+ row["TONG_SO"] + "</b>");
                        html.Append("</td>");
                        html.Append("</tr>");

                        html.Append("<tr>");
                        html.Append("<td colspan = '2' style = 'width:100%; text-align:center; padding:10px 0 0 10px; margin:0 auto'>");
                        html.Append("<table class='bkg -tranfer' cellspacing='0' style='border-top:1px solid #000; border-right:1px solid #000; border-left:1px solid #000'>");
                        html.Append("<tr>");
                        html.Append("<th style = 'width:30px; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000' class='text-center'><b>STT</b></th>");
                        html.Append("<th style = 'width:150px; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000' class='text-center'><b>Số, ngày thụ lý</b></th>");
                        html.Append("<th style = 'width:150px; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000' class='text-center'><b>Bị cáo</b></th>");
                        html.Append("<th style = 'width:110px; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000' class='text-center'><b>Tội danh</b></th>");
                        html.Append("<th style = 'width:110px; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000' class='text-center'><b>Tổng số bút lục</b></th>");
                        html.Append("<th style = 'width:110px; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000' class='text-center'> <b>Thẩm phán</b></th>");
                        html.Append("<th style = 'width:110px; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000' class='text-center'> <b>Hội đồng hủy</b></th>");
                        html.Append("<th style = 'width:60px; padding:5px; border-bottom:1px solid #000' class='text-center'> <b>Ghi chú</b></th>");
                        html.Append("</tr>");
                        decimal stt = 0;
                        foreach (DataRow rowan in tbl_anpc.Rows)
                        {
                            if (row["LOAI_AN"].ToString() == rowan["LOAI_AN"].ToString() && row["MA_GIAI_DOAN"].ToString() == rowan["MA_GIAI_DOAN"].ToString())
                            {
                                stt++;
                                html.Append("<tr>");
                                html.Append("<td style= 'text-align:center; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000'>" + stt + "</td>"); 
                                html.Append("<td style= 'text-align:center; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000'><p style ='padding:0; margin:0;'>" + rowan["SO_THU_LY"]+ "</p>" + rowan["NGAY_THU_LY"] + "</td>");
                                html.Append("<td style= 'text-align:left; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000'></td>");
                                html.Append("<td style= 'text-align:left; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000'>" + rowan["TEN_VU_AN"] + "</td>");
                                html.Append("<td style= 'text-align:left; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000'></td>");
                                html.Append("<td style= 'text-align:left; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000'>" + rowan["HOTEN"] + "</td>");
                                html.Append("<td style= 'text-align:left; padding:5px; border-right:1px solid #000; border-bottom:1px solid #000'></td>");
                                html.Append("<td style= 'text-align:left; padding:5px; solid #000; border-bottom:1px solid #000'></td>");
                                html.Append("</tr>");
                            }
                        }
                        
                        html.Append("</table>");

                        html.Append("</td>");
                        html.Append("</tr>");
                        html.Append("</table>");
                        html.Append("<p style = 'page-break-after:always;' ></ p >");
                    }                    
                    string strText = html.ToString();
                    ////Append the HTML string to Placeholder.
                    placeholder.Controls.Add(new Literal { Text = html.ToString() });
                }

            }
            catch (Exception ex)
            {              
            }
        }

        protected void lbxuatfile_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/vnd.openxmlformatsofficedocument.wordprocessingml.documet";
            Response.AddHeader("Content-Disposition", "attachment; filename=BAO_CAO_PCANN.doc");
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "";
            EnableViewState = false;
            System.IO.StringWriter writer = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter html = new System.Web.UI.HtmlTextWriter(writer);
            placeholder.RenderControl(html);
            Response.Write(writer);
            Response.End();
        }
    }
}