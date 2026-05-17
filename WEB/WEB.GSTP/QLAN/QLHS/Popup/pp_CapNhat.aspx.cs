using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.GDTTT;

namespace WEB.GSTP.QLAN.QLHS.Popup
{
    public partial class pp_CapNhat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        static decimal MAHOSO = 0;
         
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmd_exels);
            if (!IsPostBack)
            {
                hddVuViecID.Value = Request["VuViecID"] + "";
                hddLoaiAn.Value = Request["LoaiAn"] + "";
                hddCapxx.Value = Request["Capxx"] + "";
                var TRANGTHAI = Request["TRANGTHAI"] + "";

                if (!string.IsNullOrEmpty(hddVuViecID.Value) && !string.IsNullOrEmpty(hddLoaiAn.Value) && !string.IsNullOrEmpty(hddCapxx.Value) && !string.IsNullOrEmpty(TRANGTHAI))
                {

                }
                else
                {
                    var strMsg = "Lỗi thiếu thông tin";
                    Literal lt = new Literal();
                    lt.Text = "<script>window.opener.location.replace('/QLAN/QLHS/Quanlyhosoan.aspx');alert('" + strMsg + "');window.close();</script>";
                    this.Page.Controls.Add(lt);
                    return;
                }



                dllCapNhatTrangThai.Items.Clear();
                if (TRANGTHAI == "0")
                {
                    dllCapNhatTrangThai.Items.Add(new ListItem("Lưu hồ sơ", "1"));

                }

                if (TRANGTHAI == "0")
                {
                    dllCapNhatTrangThai.Enabled = false;
                    TRANGTHAI = "1";
                }
                else
                {
                    dllCapNhatTrangThai.Enabled = true;
                }

                if (TRANGTHAI == "1")
                {
                    dllCapNhatTrangThai.Items.Add(new ListItem("Lưu hồ sơ", "1"));

                    //dllCapNhatTrangThai.Items.Add(new ListItem("Cho mượn", "2"));
                    //dllCapNhatTrangThai.Items.Add(new ListItem("Chuyển hồ sơ", "3"));
                }

                //if (TRANGTHAI == "2")
                //{
                //    dllCapNhatTrangThai.Items.Add(new ListItem("Cho mượn", "2"));
                //    dllCapNhatTrangThai.Items.Add(new ListItem("Nhận lại hồ sơ", "1"));

                //}

                //if (TRANGTHAI == "3")
                //{
                //    dllCapNhatTrangThai.Items.Add(new ListItem("Đã chuyển", "3"));
                //}

                //Lưu hồ sơ =1 ==> chuyển hồ sơ = 3 ==> không xử lý nữa
                //Lưu hồ sơ =1 ==> cho mượn hồ sơ =2 ==> Nhận lại hồ sơ = 1



                dllCapNhatTrangThai.SelectedValue = TRANGTHAI;

                decimal IDVuViec = decimal.Parse(hddVuViecID.Value);
                decimal LOAIAN = decimal.Parse(hddLoaiAn.Value);
                decimal Capxx = decimal.Parse(hddCapxx.Value);
                QLHS_STPT oT = dt.QLHS_STPT.Where(x => x.VUVIECID == IDVuViec && x.LOAIAN == LOAIAN && x.CAPXX == Capxx).FirstOrDefault();
                if (oT != null)
                {

                    MAHOSO = oT.ID;


                    Load_Data(oT.ID);


                    if (oT.NGAYGIAONHAN.HasValue)
                    {
                        txtNgaygiao.Text = oT.NGAYGIAONHAN.Value.ToString("dd/MM/yyyy");
                    }
                    txtSoBuLuc.Text = "" + oT.SOBUTLUC;
                    txtGQGhichu.Text = oT.GHICHU;



                    txtKhoLuuTru.Text = oT.KHOLUUTRU;
                    txtKhungLuuTru.Text = oT.KHUNGLUUTRU;
                    txtPhongLuuTru.Text = oT.PHONGLUUTRU;
                    txtSoGia.Text = oT.SOGIA;
                    txtSoHop.Text = oT.SOHOP;
                    txtSoQuyen.Text = oT.SOQUYEN;
                }
                else
                {
                    dgList.Visible = false;
                    cmd_exels.Visible = false;
                }
                //Xử lý 


            }
        }






        protected void cmdCapnhat_Click(object sender, EventArgs e)
        {
            lbthongBaoUpdate.Text = "";

            var TrangThai = int.Parse(dllCapNhatTrangThai.SelectedValue);

            #region Validate Data

            //if (TrangThai == 0 || TrangThai == 1)
            //{

            //}
            //else
            //{

            if (Cls_Comon.IsValidDate(txtNgaygiao.Text) == false)
            {
                lbthongBaoUpdate.Text = "Bạn phải nhập ngày nhận theo định dạng (dd/MM/yyyy)!";
                txtNgaygiao.Focus();
                return;
            }

            if (txtSoBuLuc.Text.Length <= 0)
            {
                lbthongBaoUpdate.Text = "Bạn chưa nhập số bút lục. Hãy chọn lại!";
                txtSoBuLuc.Focus();
                return;
            }

            //}
            #endregion
            if (!string.IsNullOrEmpty(txtSoBuLuc.Text))
            {
                decimal check = 0;
                if (!decimal.TryParse(txtSoBuLuc.Text, out check))
                {
                    lbthongBaoUpdate.Text = "Số bút lục là kiểu số. Hãy chọn lại!";
                    txtSoBuLuc.Focus();
                    return;
                }
            }



            //
            decimal IDVuViec = Convert.ToDecimal(hddVuViecID.Value);
            var LOAIAN = decimal.Parse(hddLoaiAn.Value);
            var Capxx = decimal.Parse(hddCapxx.Value);

            decimal TrangThaiCu = 1;


            QLHS_STPT oT = dt.QLHS_STPT.Where(x => x.VUVIECID == IDVuViec && x.LOAIAN == LOAIAN && x.CAPXX == Capxx).FirstOrDefault();

            if (oT == null)
            {
                oT = new QLHS_STPT();
                oT.VUVIECID = IDVuViec;
                oT.CAPXX = Capxx;
                oT.LOAIAN = LOAIAN;
                oT.GHICHU = txtGQGhichu.Text;

                oT.NGAYGIAONHAN = txtNgaygiao.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaygiao.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                //if (!string.IsNullOrEmpty(ddNguoinhan.SelectedValue) && ddNguoinhan.SelectedValue != "0")
                //{
                //    oT.NGUOINHANID = Convert.ToDecimal(ddNguoinhan.SelectedValue);
                //    oT.TENNGUOINHAN = ddNguoinhan.SelectedItem.Text;
                //}



                if (!string.IsNullOrEmpty(txtSoBuLuc.Text))
                {
                    oT.SOBUTLUC = Convert.ToDecimal(txtSoBuLuc.Text);
                }


                oT.KHOLUUTRU = txtKhoLuuTru.Text;
                oT.KHUNGLUUTRU = txtKhungLuuTru.Text;
                oT.PHONGLUUTRU = txtPhongLuuTru.Text;
                oT.SOGIA = txtSoGia.Text;
                oT.SOHOP = txtSoHop.Text;
                oT.SOQUYEN = txtSoQuyen.Text;


                oT.GHICHU = txtGQGhichu.Text;

                oT.TRANGTHAIID = 1;

                oT.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");


                oT.NGAYTAO = DateTime.Now;
                dt.QLHS_STPT.Add(oT);


            }
            else
            {
                TrangThaiCu = oT.TRANGTHAIID ?? 1;
                //Nếu mà trạng thái  mới và đã lưu thì chỉ cập nhật trạng thái 



                oT.NGAYGIAONHAN = txtNgaygiao.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaygiao.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                oT.SOBUTLUC = Convert.ToDecimal(txtSoBuLuc.Text);
                oT.GHICHU = txtGQGhichu.Text;
                oT.NGUOISUA = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                oT.NGAYSUA = DateTime.Now;
                oT.TRANGTHAIID = TrangThai;
                oT.KHOLUUTRU = txtKhoLuuTru.Text;
                oT.KHUNGLUUTRU = txtKhungLuuTru.Text;
                oT.PHONGLUUTRU = txtPhongLuuTru.Text;
                oT.SOGIA = txtSoGia.Text;
                oT.SOHOP = txtSoHop.Text;
                oT.SOQUYEN = txtSoQuyen.Text;



            }


            dt.SaveChanges(); 
            var strMsg = "Cập nhật thành công";
            lbthongBaoUpdate.Text = strMsg;
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent()");

            //Literal lt = new Literal();
            //lt.Text = "<script>window.opener.location.replace('/QLAN/QLHS/Quanlyhosoan.aspx');alert('" + strMsg + "');window.close();</script>";
            //this.Page.Controls.Add(lt);

        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {

            try
            {
                Literal lt = new Literal();
                //if (QuanLyHoSo_SAVE > 0)
                //{
                //    lt.Text = "<script>window.opener.location.replace('/QLAN/QLHS/Quanlyhosoan.aspx');window.close();</script>";
                //}
                //else
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
                //lt.Text = "<script>window.opener.location.replace('/QLAN/QLHS/Quanlyhosoan.aspx');window.close();</script>";

                this.Page.Controls.Add(lt);
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
        }


        public void Load_Data(decimal ID)
        {
            dgList.Visible = false;
            var lichsu = dt.QLHS_STPT_LICHSU.Where(t => t.MAHS == ID).OrderByDescending(t => t.NGAYGIAONHAN).ToList().Select(t => new QLHS_STPT_LICHSU_CUSTOM()
            {
                ID = t.ID,
                MAHS = t.MAHS,
                TRANGTHAIID = t.TRANGTHAIID,
                //TENTRANGTHAI =t.TENTRANGTHAI,
                NGUOICHOMUONID = t.NGUOICHOMUONID,
                TENNGUOICHOMUON = t.TENNGUOICHOMUON,
                NGUOIMUONID = t.NGUOIMUONID,
                TENNGUOIMUON = t.TENNGUOIMUON,
                DONVIID = t.DONVIID,
                DONVIMUON = t.DONVIMUON,
                SOBUTLUC = t.SOBUTLUC,
                GHICHU = t.GHICHU,
                NGUOITAO = t.NGUOITAO,
                NGAYTAO = t.NGAYTAO,
                LOAITOAAN = t.LOAITOAAN,
                KHOLUUTRU = t.KHOLUUTRU,
                KHUNGLUUTRU = t.KHUNGLUUTRU,
                PHONGLUUTRU = t.PHONGLUUTRU,
                SOGIA = t.SOGIA,
                SOHOP = t.SOHOP,
                SOQUYEN = t.SOQUYEN,
            }).ToList();

            if (lichsu.Count == 0)
            {
                cmd_exels.Visible = false;
            }
            //1:Cho muon; 2:Hồ sơ đã chuyển; 3: Tra HS
            for (int i = 0; i < lichsu.Count; i++)
            {
                if (lichsu[i].TRANGTHAIID == 1)
                {
                    lichsu[i].TENTRANGTHAI = "Cho mượn";
                }
                if (lichsu[i].TRANGTHAIID == 2)
                {
                    lichsu[i].TENTRANGTHAI = "Hồ sơ đã chuyển";
                }
                if (lichsu[i].TRANGTHAIID == 3)
                {
                    lichsu[i].TENTRANGTHAI = "Lưu hồ sơ";
                }
            }

            dgList.DataSource = lichsu;
            dgList.DataBind();
        }

        protected void cmdExport_Click(object sender, EventArgs e)
        {
            try
            {

                ExportGridToExcel();
            }
            catch (Exception ex) { }
        }

        private void ExportGridToExcel()
        {
            var lichsu = dt.QLHS_STPT_LICHSU.Where(t => t.MAHS == MAHOSO).OrderByDescending(t => t.ID).ToList().Select(t => new QLHS_STPT_LICHSU_CUSTOM()
            {
                ID = t.ID,
                MAHS = t.MAHS,
                TRANGTHAIID = t.TRANGTHAIID,
                //TENTRANGTHAI =t.TENTRANGTHAI,
                NGUOICHOMUONID = t.NGUOICHOMUONID,
                TENNGUOICHOMUON = t.TENNGUOICHOMUON,
                NGUOIMUONID = t.NGUOIMUONID,
                TENNGUOIMUON = t.TENNGUOIMUON,
                DONVIID = t.DONVIID,
                DONVIMUON = t.DONVIMUON,
                SOBUTLUC = t.SOBUTLUC,
                GHICHU = t.GHICHU,
                NGUOITAO = t.NGUOITAO,
                NGAYTAO = t.NGAYTAO,
                LOAITOAAN = t.LOAITOAAN,
                KHOLUUTRU = t.KHOLUUTRU,
                KHUNGLUUTRU = t.KHUNGLUUTRU,
                PHONGLUUTRU = t.PHONGLUUTRU,
                SOGIA = t.SOGIA,
                SOHOP = t.SOHOP,
                SOQUYEN = t.SOQUYEN,
            }).ToList();

            if (lichsu.Count == 0)
            {
                var strMsg = "Không có dữ liệu";
                Literal lt = new Literal();
                lt.Text = "<script>window.opener.location.replace('/QLAN/QLHS/Quanlyhosoan.aspx');alert('" + strMsg + "');</script>";
                this.Page.Controls.Add(lt);
                return;
            }

            //1:Cho muon; 2:Hồ sơ đã chuyển; 3: Tra HS
            for (int i = 0; i < lichsu.Count; i++)
            {
                if (lichsu[i].TRANGTHAIID == 1)
                {
                    lichsu[i].TENTRANGTHAI = "Cho mượn";
                }
                if (lichsu[i].TRANGTHAIID == 2)
                {
                    lichsu[i].TENTRANGTHAI = "Hồ sơ đã chuyển";
                }
                if (lichsu[i].TRANGTHAIID == 3)
                {
                    lichsu[i].TENTRANGTHAI = "Lưu hồ sơ";
                }
            }

            var html = "";
            html = html + @"<table cellpadding='0' cellspacing='1' style='font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;'>";
            html = html + @"<tr class='header'>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>TT</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Trạng thái</th>";

            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Đơn vị nhận</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Tên người nhận</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Tên người chuyển</th>";

            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Số bút lục</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Kho lưu trữ</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Khung lưu trữ</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Phòng lưu trữ</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Số giá</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Số hộp</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 1pt solid Black;'>Số cặp/quyển</th>";
            html = html + @" </tr>";


            for (int i = 0; i < lichsu.Count; i++)
            {



                html = html + @"<tr class='chan'>";
                html = html + @" <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + (i + 1) + "</td>";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'> " + lichsu[i].TENTRANGTHAI + "  </td>";

                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].DONVIMUON + "</td>";
                html = html + @" <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'> " + lichsu[i].TENNGUOIMUON + "</td>";

                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'> " + lichsu[i].TENNGUOICHOMUON + "</td>";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].SOBUTLUC + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].KHOLUUTRU + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].KHUNGLUUTRU + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].PHONGLUUTRU + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].SOGIA + "</td> ";
                html = html + @"  <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].SOHOP + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].SOQUYEN + "</td> ";

                html = html + @"</tr> ";

            }

            html = html + @"<table>";

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=QUANLYHOSO_STPT_CHITIET.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");

            Response.Write(html);
            try
            {
                Response.End();
            }
            catch
            {


            }
        }

    }




    public class QLHS_STPT_LICHSU_CUSTOM
    {
        public decimal ID { get; set; }
        public Nullable<decimal> MAHS { get; set; }
        public Nullable<decimal> TRANGTHAIID { get; set; }
        public string TENTRANGTHAI { get; set; }
        public Nullable<decimal> NGUOICHOMUONID { get; set; }
        public string TENNGUOICHOMUON { get; set; }
        public Nullable<decimal> NGUOIMUONID { get; set; }
        public string TENNGUOIMUON { get; set; }
        public Nullable<decimal> DONVIID { get; set; }
        public string DONVIMUON { get; set; }
        public Nullable<decimal> SOBUTLUC { get; set; }
        public string GHICHU { get; set; }
        public string NGUOITAO { get; set; }
        public Nullable<System.DateTime> NGAYTAO { get; set; }
        public Nullable<decimal> LOAITOAAN { get; set; }
        public string KHOLUUTRU { get; set; }
        public string KHUNGLUUTRU { get; set; }
        public string PHONGLUUTRU { get; set; }
        public string SOGIA { get; set; }
        public string SOHOP { get; set; }
        public string SOQUYEN { get; set; }
    }
}