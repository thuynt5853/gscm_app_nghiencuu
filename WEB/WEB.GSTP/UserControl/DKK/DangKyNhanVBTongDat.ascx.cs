using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK;
using System.Globalization;
using Module.Common;
using DAL.GSTP;
using System.Data;
namespace WEB.GSTP.UserControl.DKK
{
    public partial class DangKyNhanVBTongDat : System.Web.UI.UserControl
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected int MaHeThong_QuanTri = 5;
        protected string MaChuongTrinh_DKK = "QTDKK";
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                if (Convert.ToInt16(Session["MaHeThong"] + "") == MaHeThong_QuanTri)
                    LoadDAta();
                else pn.Visible = false;
            }
        }
        void LoadDAta()
        {
            String StrDangKyNhanVB = "";
            string temp = "";
            int count_index = 0;
            decimal ToaAnID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + ""))? 0:Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            //DateTime hom_truoc = Convert.ToDateTime(DateTime.Now.AddDays(-1).ToShortDateString());
            // DateTime now = Convert.ToDateTime(DateTime.Now.ToShortDateString());

            //---------------------------------
            List<DONKK_USER_DKNHANVB> lst = dt.DONKK_USER_DKNHANVB.Where(x => x.TOAANID == ToaAnID).ToList<DONKK_USER_DKNHANVB>();
            if (lst != null && lst.Count > 0)
            {
                count_index++;
              
                temp = "<ul class='home_ul_child'>";
                List<DONKK_USER_DKNHANVB> lstChild = lst.Where(x => x.TRANGTHAI == 1).ToList<DONKK_USER_DKNHANVB>();
                if (lstChild != null && lstChild.Count > 0)
                    temp += "<li>Số lượng đăng ký đang giao dịch điện tử: " + lstChild.Count.ToString() + "</li>";
                //-------------------------------
                lstChild = lst.Where(x => x.TRANGTHAI == 0).ToList<DONKK_USER_DKNHANVB>();
                if (lstChild != null && lstChild.Count > 0)
                    temp += "<li>Số lượng đăng ký đã ngừng giao dịch điện tử: " + lstChild.Count.ToString() + "</li>";

                temp += "</ul>";

                //-----------------------------------                
                StrDangKyNhanVB = "<li><b>" + count_index.ToString() + ". Đăng ký nhận văn bản, thông báo từ Tòa án</b>";
                
                StrDangKyNhanVB += temp;
                StrDangKyNhanVB += "</li>";
            }
            //---------------------------------
            String StrDonKK = "";
            DONKK_DON_BL objBL = new DONKK_DON_BL();
            DataTable tbl = objBL.ThongKe(ToaAnID);
            if (tbl != null && tbl.Rows.Count>0)
            {
                int trangthai = 0;
                Decimal count_da_phanloai = 0;
                String temp_daphanloai = "";
                temp = "";
                foreach(DataRow row in tbl.Rows)
                {
                    trangthai = Convert.ToInt16(row["TrangThai"]+"");
                    if (trangthai == 0)
                        temp = "<li>Đơn chưa phân loại: " + row["CountItem"].ToString() + "</li>";
                    else
                    {
                        count_da_phanloai += Convert.ToDecimal(row["CountItem"]+"");
                        //temp_daphanloai += "<li>" + row["TrangThaiHoSo"].ToString() + ": " + row["CountItem"].ToString() + "</li>";
                        switch(trangthai)
                        {
                            case 1:
                                if (temp_daphanloai.Length > 0)
                                    temp_daphanloai += ", ";
                                temp_daphanloai += "<b>Chưa giải quyết: </b>" + row["CountItem"] + "";
                                break;
                            case 3:
                                if (temp_daphanloai.Length > 0)
                                    temp_daphanloai += ", ";
                                temp_daphanloai += "<b>Trả lại: </b>" + row["CountItem"] + "";
                                break;
                            case 4:
                                if (temp_daphanloai.Length > 0)
                                    temp_daphanloai += ", ";
                                temp_daphanloai += "<b>Bổ sung: </b>" + row["CountItem"] + "";
                                break;
                            case 5:
                                if (temp_daphanloai.Length > 0)
                                    temp_daphanloai += ", ";
                                temp_daphanloai += "<b>Thụ lý: </b>" + row["CountItem"] + "";
                                break;
                        }
                    }
                }
                if (count_da_phanloai > 0)
                {
                    temp += "<li>Đơn đã phân loại: " + count_da_phanloai.ToString() ;
                    //  temp += "<ul class='home_ul_child'>" + temp_daphanloai +  "</ul>";
                    temp += "<span style='margin-left:7px;'>(" + temp_daphanloai + ")</span>";
                    temp += "</li>";
                }
                //---------------------------------
                count_index++;
                StrDonKK = "<li><b>" + count_index.ToString() + ". Đơn khởi kiện trực tuyến</b>";
                StrDonKK += "<ul class='home_ul_child'>";
                StrDonKK += temp;
                StrDonKK += "</ul>";
                StrDonKK += "</li>";
            }
            //---------------------------------
            lkDKNhanVB.Text = StrDangKyNhanVB + StrDonKK;

            //-----------------------------------------
            int NhomQuyenQuanTri = 0;
            Decimal CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID>0)
            {
                QT_NGUOISUDUNG objUser = gsdt.QT_NGUOISUDUNG.Where(x => x.ID == CurrentUserID).Single<QT_NGUOISUDUNG>();
                NhomQuyenQuanTri = (int)objUser.NHOMNSDID;
                if (NhomQuyenQuanTri == ENUM_NHOMQUYEN.QUANTRIHT)
                    Load_ThongBao_QuanTri(count_index + 1);
                else
                    lkAdmin_NguoiDung.Visible = false;
            }

            if (lkDKNhanVB.Visible == true || lkAdmin_NguoiDung.Visible == true)
                pn.Visible = true;
            else
                pn.Visible = false;
        }

        protected void lkDKNhanVB_Click(object sender, EventArgs e)
        {
            //Session["MaHeThong"] = MaHeThong_QuanTri;
            //Session["MaChuongTrinh"] = MaChuongTrinh_DKK;
            //Response.Redirect("/QTDKK/QLNhanVBTongDat/Danhsach.aspx");
        }
        
        //---------------------------------------
        void Load_ThongBao_QuanTri(int count_index)
        {
            string temp = "";
            //-1.NguoidungDKK-------------------------------------
            string menu_text = "Danh mục tài khoản người dùng";
            List<DONKK_USERS> lstUser = dt.DONKK_USERS.ToList<DONKK_USERS>();
            if (lstUser != null && lstUser.Count > 0)
            {
                temp = "<ul class='home_ul_child'>";
                // 0, 'Chưa kích hoạt', 1, 'Đang khóa', 2, 'Đang hoạt động',''                
                List<DONKK_USERS> lstStatus = lstUser.Where(x => x.STATUS == 0).ToList<DONKK_USERS>();
                if (lstStatus != null && lstStatus.Count > 0)
                    temp += "<li>Số lượng tài khoản chưa kích hoạt: " + lstStatus.Count + "</li>";
             
                //------------------------------
                lstStatus = lstUser.Where(x => x.STATUS == 1).ToList<DONKK_USERS>();
                if (lstStatus != null && lstStatus.Count > 0)
                    temp += "<li>Số lượng tài khoản đang bị khóa: " + lstStatus.Count + "</li>";
                //------------------------------
                lstStatus = lstUser.Where(x => x.STATUS == 2).ToList<DONKK_USERS>();
                if (lstStatus != null && lstStatus.Count > 0)
                    temp += "<li>Số lượng tài khoản đang sử dụng: " + lstStatus.Count + "</li>";
                temp += "</ul>";
                
                //-----------------------------------------------
                lkAdmin_NguoiDung.Text = "<li><b>"+ count_index.ToString() +". " + menu_text + ": </b>";
                lkAdmin_NguoiDung.Text += temp;
                lkAdmin_NguoiDung.Text += "</li>";
                lkAdmin_NguoiDung.Visible = true;
            }
            else
                lkAdmin_NguoiDung.Visible = false;
            //--------------------------------------
        }
        protected void lkAdmin_NguoiDung_Click(object sender, EventArgs e)
        {
            Session["MaHeThong"] = MaHeThong_QuanTri;
            Session["MaChuongTrinh"] = MaChuongTrinh_DKK;
            Response.Redirect("/QTDKK/DSTaikhoanND/Danhsach.aspx");
        }
    }
}