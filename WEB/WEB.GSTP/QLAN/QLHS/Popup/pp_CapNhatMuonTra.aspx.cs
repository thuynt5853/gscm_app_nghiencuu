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
    public partial class pp_CapNhatMuonTra : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        static string TRANGTHAI = "";
        static string TRANGTHAI_LICHSU_CURRENT = "";
        static decimal MAHOSO = 0;
        static string SOBANAN = "";
        static string NGAYBANAN = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmd_exels);
            if (!IsPostBack)
            {

                LoadNguoiChuyen();


                hddVuViecID.Value = Request["VuViecID"] + "";
                hddLoaiAn.Value = Request["LoaiAn"] + "";
                hddCapxx.Value = Request["Capxx"] + "";
                SOBANAN = Server.HtmlDecode(Request["SOBANAN"] + "");
                NGAYBANAN = Server.HtmlDecode(Request["NGAYBANAN"] + "");
                //TRANGTHAI = Request["TRANGTHAI"] + "";

                if (!string.IsNullOrEmpty(hddVuViecID.Value) && !string.IsNullOrEmpty(hddLoaiAn.Value) && !string.IsNullOrEmpty(hddCapxx.Value))
                {

                }
                else
                {
                    var strMsg = "Lỗi thiếu thông tin";
                    Literal lt = new Literal();
                    lt.Text = "<script>window.opener.location.replace('/QLAN/QLHS/QuanlyMuonTra.aspx');alert('" + strMsg + "');window.close();</script>";
                    this.Page.Controls.Add(lt);
                    return;
                }

                var donvinhan = "";


                decimal IDVuViec = decimal.Parse(hddVuViecID.Value);
                decimal LOAIAN = decimal.Parse(hddLoaiAn.Value);
                decimal Capxx = decimal.Parse(hddCapxx.Value);

                txtNgaygiao.Text = DateTime.Now.ToString("dd/MM/yyyy");

                QLHS_STPT oTSTPT = dt.QLHS_STPT.Where(x => x.VUVIECID == IDVuViec && x.LOAIAN == LOAIAN && x.CAPXX == Capxx).FirstOrDefault();
                if (oTSTPT != null)
                {
                    TRANGTHAI = "" + oTSTPT.TRANGTHAIID;
                    MAHOSO = oTSTPT.ID;
                    Load_Data(oTSTPT.ID);



                    txtTenNguoiNhan.Text = "" + oTSTPT.TENNGUOINHAN;
                    ddlNguoichuyen.SelectedValue = "" + oTSTPT.NGUOICHUYENID;

                    txtSoBuLuc.Text = "" + oTSTPT.SOBUTLUC;

                    rbLoaiDonVi.SelectedValue = "" + oTSTPT.LOAITOAAN;

                    donvinhan = "" + oTSTPT.DONVIID;
                    txtDonViNhan.Text = "" + oTSTPT.TENDONVI;

                    txtKhoLuuTru.Text = oTSTPT.KHOLUUTRU;
                    txtKhungLuuTru.Text = oTSTPT.KHUNGLUUTRU;
                    txtPhongLuuTru.Text = oTSTPT.PHONGLUUTRU;
                    txtSoGia.Text = oTSTPT.SOGIA;
                    txtSoHop.Text = oTSTPT.SOHOP;
                    txtSoQuyen.Text = oTSTPT.SOQUYEN;


                    //mặc định load theo giá trị cuối cùng
                    var lichsuCuoi = dt.QLHS_STPT_LICHSU.Where(x => x.MAHS == oTSTPT.ID).OrderByDescending(t => t.ID).FirstOrDefault();
                    if (lichsuCuoi != null)
                    {

                        TRANGTHAI_LICHSU_CURRENT = "" + lichsuCuoi.TRANGTHAIID;

                        ddlNguoichuyen.SelectedValue = "" + lichsuCuoi.NGUOICHOMUONID;


                        txtSoBuLuc.Text = "" + lichsuCuoi.SOBUTLUC;
                        txtGQGhichu.Text = lichsuCuoi.GHICHU;

                        rbLoaiDonVi.SelectedValue = "" + lichsuCuoi.LOAITOAAN;




                        txtKhoLuuTru.Text = lichsuCuoi.KHOLUUTRU;
                        txtKhungLuuTru.Text = lichsuCuoi.KHUNGLUUTRU;
                        txtPhongLuuTru.Text = lichsuCuoi.PHONGLUUTRU;
                        txtSoGia.Text = lichsuCuoi.SOGIA;
                        txtSoHop.Text = lichsuCuoi.SOHOP;
                        txtSoQuyen.Text = lichsuCuoi.SOQUYEN;


                        donvinhan = "" + lichsuCuoi.DONVIID;
                        txtDonViNhan.Text = "" + lichsuCuoi.DONVIMUON;
                        txtTenNguoiNhan.Text = "" + lichsuCuoi.TENNGUOIMUON;

                        //ddDonViNhan.SelectedValue = "0";
                        //txtTenNguoiNhan.Text = "";
                        //if (lichsuCuoi.TRANGTHAIID == 3) //cập nhật Lưu trữ và nhận lại hồ sơ
                        //{
                        //    //ddDonViNhan.SelectedValue = "0";
                        //    //txtTenNguoiNhan.Text = "";

                        //    ddDonViNhan.SelectedValue = "" + lichsuCuoi.DONVIID;
                        //    txtTenNguoiNhan.Text = "" + lichsuCuoi.TENNGUOIMUON;
                        //}
                        //if (lichsuCuoi.TRANGTHAIID == 1) //cập nhật Phiếu mượn
                        //{
                        //    ddDonViNhan.SelectedValue = "" + lichsuCuoi.DONVIID;
                        //    txtTenNguoiNhan.Text = "" + lichsuCuoi.TENNGUOIMUON;
                        //}
                        //if (lichsuCuoi.TRANGTHAIID == 2) //Phiếu chuyển
                        //{
                        //    ddDonViNhan.SelectedValue = "" + lichsuCuoi.DONVIID;
                        //    txtTenNguoiNhan.Text = "" + lichsuCuoi.TENNGUOIMUON;
                        //}

                    }
                    txtGQGhichu.Text = "";

                    LoadTrangThai();




                }
                else
                {
                    dgList.Visible = false;
                    cmd_exels.Visible = false;
                }
                //Xử lý 
                LoadDonViNhan();

                ddDonViNhan.SelectedValue = donvinhan;

                LoadLyDo();



                LoadEnableControl();
                showHideTextLyDo();
            }

        }


        private void LoadTrangThai(int changeTrangThai = 1)

        {
            dllCapNhatTrangThai.Items.Clear();
            if (TRANGTHAI == "0")
            {
                dllCapNhatTrangThai.Items.Add(new ListItem("Nhận hồ sơ", "1"));

            }


            if (TRANGTHAI == "1" || TRANGTHAI == "2")
            {
                dllCapNhatTrangThai.Items.Add(new ListItem("Phiếu mượn", "2"));
                dllCapNhatTrangThai.Items.Add(new ListItem("Phiếu chuyển", "3"));

                dllCapNhatTrangThai.Items.Add(new ListItem("Nhận hồ sơ", "1"));
            }

            if (TRANGTHAI == "3")
            {

                dllCapNhatTrangThai.Items.Add(new ListItem("Nhận hồ sơ", "1"));
            }
            // var lichsu = dt.QLHS_STPT_LICHSU.Where(t => t.MAHS == ID).OrderByDescending(t => t.NGAYGIAONHAN).ThenByDescending(t=>t.ID).ToList()
            //Nhận hồ sơ =1 ==> Phiếu chuyển = 3 ==> không xử lý nữa
            //Nhận hồ sơ =1 ==> Phiếu mượn hồ sơ =2 ==> Nhận lại hồ sơ = 1
            if (changeTrangThai == 2)//edit
            {
                dllCapNhatTrangThai.Items.Clear();
                if (TRANGTHAI == "0")
                {
                    dllCapNhatTrangThai.Items.Add(new ListItem("Nhận hồ sơ", "1"));

                }
                 
                if (TRANGTHAI == "1" || TRANGTHAI == "2")
                {
                    dllCapNhatTrangThai.Items.Add(new ListItem("Phiếu mượn", "2"));
                    dllCapNhatTrangThai.Items.Add(new ListItem("Phiếu chuyển", "3"));

                    dllCapNhatTrangThai.Items.Add(new ListItem("Nhận hồ sơ", "1"));
                }

                if (TRANGTHAI == "3")
                {

                    dllCapNhatTrangThai.Items.Add(new ListItem("Phiếu chuyển", "3"));
                    dllCapNhatTrangThai.Items.Add(new ListItem("Nhận hồ sơ", "1"));
                }
            }
            if (changeTrangThai == 1)
            {
                if (TRANGTHAI == "1")
                {
                    TRANGTHAI = "3";

                    if (TRANGTHAI_LICHSU_CURRENT != "1")//Trạng thái lịch sử là phiếu mượn
                    {

                        txtTenNguoiNhan.Text = "";
                        try
                        {
                            ddDonViNhan.SelectedValue = "0";
                        }
                        catch
                        {


                        }
                        try
                        {
                            var SESSION_CANBOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID]);
                            ddlNguoichuyen.SelectedValue = "" + SESSION_CANBOID;
                        }
                        catch
                        {


                        }
                    }

                }
                else if (TRANGTHAI == "3")  //Nếu là trạng thái chuyển thì set trạng thái nhận
                {
                    TRANGTHAI = "1";
                }
            }


            dllCapNhatTrangThai.SelectedValue = TRANGTHAI;

            LoadEnableControl();
        }

        private void LoadLyDo()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME("QLHS_LYDO");

            ddlLyDo.Items.Clear();


            ddlLyDo.Items.Add(new ListItem("Chọn", "-2"));

            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    var intma = 0;
                    if (int.TryParse(row["MA"].ToString(), out intma))
                    {
                        ddlLyDo.Items.Add(new ListItem(row["Ten"].ToString(), intma.ToString()));
                    }

                }

                ddlLyDo.Items.Add(new ListItem("Khác", "-1"));
            }


            ddlLyDo.SelectedValue = "-2";

            showHideTextLyDo();
        }


        private void LoadDonViNhan()
        {
            var ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            txtDonViNhan.Visible = false;
            ddDonViNhan.Visible = true;

            ddDonViNhan.Items.Clear();
            var LoaiDonVi = rbLoaiDonVi.SelectedValue;
            if (string.IsNullOrEmpty(LoaiDonVi))
            {
                LoaiDonVi = "0";
            }
            if (LoaiDonVi == "" + 0)//Load thông tin tòa án
            {

                DM_TOAAN_BL oBL = new DM_TOAAN_BL();

                var dtToaAn = dt.DM_TOAAN.Where(t => t.HIEULUC == 1).ToList();

                ddDonViNhan.Items.Add(new ListItem("Chọn", "0"));

                for (int i = 0; i < dtToaAn.Count; i++)
                {
                    ddDonViNhan.Items.Add(new ListItem("" + dtToaAn[i].MA_TEN, "" + dtToaAn[i].ID));
                }



                var dmtoaan = dtToaAn.Where(t => t.ID == ToaAnID).FirstOrDefault();
                if (dmtoaan != null)
                {
                    //ddDonViNhan.SelectedValue = dmtoaan.ID + "";
                    //if (dmtoaan.CAPCHAID.HasValue)
                    //{
                    //    ddDonViNhan.SelectedValue = dmtoaan.CAPCHAID + "";
                    //}
                }
            }
            if (LoaiDonVi == "" + 1)//Load thông tin viện kiểm soát
            {
                ddDonViNhan.Items.Add(new ListItem("Chọn", "0"));

                List<DM_VKS> lstVKS = dt.DM_VKS.Where(t => t.HIEULUC == 1).ToList();
                if (lstVKS.Count > 0)
                {
                    for (int i = 0; i < lstVKS.Count; i++)
                    {
                        ddDonViNhan.Items.Add(new ListItem(lstVKS[i].TEN, lstVKS[i].ID.ToString()));
                    }

                    if (!string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + ""))
                    {

                        DM_VKS vks = lstVKS.Where(x => x.TOAANID == ToaAnID).FirstOrDefault<DM_VKS>();
                        if (vks != null)
                        {
                            //ddDonViNhan.SelectedValue = vks.ID + "";
                        }
                        //if (vks != null && vks.CAPCHAID.HasValue)
                        //{
                        //    ddDonViNhan.SelectedValue = vks.CAPCHAID + "";
                        //}
                    }
                }
            }

            if (LoaiDonVi == "" + 2) //khác
            {
                ddDonViNhan.Items.Clear();
                ddDonViNhan.Items.Add(new ListItem("", ""));

                txtDonViNhan.Visible = true;
                ddDonViNhan.Visible = false;
            }
        }

        private void LoadNguoiChuyen()
        {


            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            //DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);

            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY);

            DataTable oCBDTTTV = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_TTV);

            DataTable oCBDTLTV = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_LTV);

            if (oCBDTTTV != null && oCBDTTTV.Rows.Count > 0)
            {
                oCBDT.Merge(oCBDTTTV);
            }

            if (oCBDTLTV != null && oCBDTLTV.Rows.Count > 0)
            {
                oCBDT.Merge(oCBDTLTV);
            }

            ddlNguoichuyen.DataSource = oCBDT;
            ddlNguoichuyen.DataTextField = "MA_TEN";

            ddlNguoichuyen.DataValueField = "ID";
            ddlNguoichuyen.DataBind();
            ddlNguoichuyen.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            try
            {
                var SESSION_CANBOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID]);
                ddlNguoichuyen.SelectedValue = "" + SESSION_CANBOID;
            }
            catch
            {


            }


        }


        protected void rbLoaiDonVi_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDonViNhan();
            //Load_Data();
        }

        private void LoadEnableControl()
        {
            lblSoButLuc.Visible = false;
            lblKhoLuuTru.Visible = false;
            lblKhungLuuTru.Visible = false;
            lblPhongLuuTru.Visible = false;
            lblSoGia.Visible = false;
            lblSoHop.Visible = false;
            lblSoQuyen.Visible = false;
            //lblGQGhichu.Visible = false;



            txtSoBuLuc.Visible = false;
            txtKhoLuuTru.Visible = false;
            txtKhungLuuTru.Visible = false;
            txtPhongLuuTru.Visible = false;
            txtSoGia.Visible = false;
            txtSoHop.Visible = false;
            txtSoQuyen.Visible = false;
            //txtGQGhichu.Visible = false;

            lblLyDoChuyen.Visible = false;
            ddlLyDo.Visible = false;
            txtLyDo.Visible = false;

            //lblNguoiChuyen.Visible = true;
            //ddlNguoichuyen.Visible = true;


            lblNguoiChuyen.Visible = true;
            ddlNguoichuyen.Visible = true;


            if (dllCapNhatTrangThai.SelectedValue == "3")//Phiếu mượn
            {
                lblLyDoChuyen.Visible = true;
                ddlLyDo.Visible = true;
                txtLyDo.Visible = true;

                lblSoButLuc.Visible = true;
                txtSoBuLuc.Visible = true;
            }

            if (dllCapNhatTrangThai.SelectedValue == "2")//Phiếu mượn
            {
                lblNguoiChuyen.Visible = false;
                ddlNguoichuyen.Visible = false;


                lblSoButLuc.Visible = true;
                txtSoBuLuc.Visible = true;
            }
            if (dllCapNhatTrangThai.SelectedValue == "1")//Phiếu nhận
            {

                lblSoButLuc.Visible = true;
                lblKhoLuuTru.Visible = true;
                lblKhungLuuTru.Visible = true;
                lblPhongLuuTru.Visible = true;
                lblSoGia.Visible = true;
                lblSoHop.Visible = true;
                lblSoQuyen.Visible = true;
                lblGQGhichu.Visible = true;

                lblSoButLuc.Visible = true;
                txtSoBuLuc.Visible = true;
                txtKhoLuuTru.Visible = true;
                txtKhungLuuTru.Visible = true;
                txtPhongLuuTru.Visible = true;
                txtSoGia.Visible = true;
                txtSoHop.Visible = true;
                txtSoQuyen.Visible = true;
                //txtGQGhichu.Visible = true;
            }
            //Xử lý change text khi thay đổi trạng thái chuyển
            lblDonViNhan.Text = "Đơn vị nhận<span class='batbuoc'>(*)</span>";
            lblNguoiNhan.Text = "Người nhận";
            lblNguoiChuyen.Text = "Người chuyển<span class='batbuoc'>(*)</span>";

            lblNgayGiao.Text = "Ngày nhận";
            if (dllCapNhatTrangThai.SelectedValue == "1")// Lưu hồ sơ 
            {
                lblDonViNhan.Text = "Đơn vị trả<span class='batbuoc'>(*)</span>";
                lblNguoiNhan.Text = "Người trả";
                lblNguoiChuyen.Text = "Người nhận<span class='batbuoc'>(*)</span>";

                lblNgayGiao.Text = "Ngày nhận";


                txtTenNguoiNhan.Text = "";
            }

            if (dllCapNhatTrangThai.SelectedValue == "2")//Mượn

            {
                lblDonViNhan.Text = "Đơn vị mượn<span class='batbuoc'>(*)</span>";
                lblNguoiNhan.Text = "Người mượn";
                lblNguoiChuyen.Text = "Người chuyển<span class='batbuoc'>(*)</span>";


                lblNgayGiao.Text = "Ngày mượn";
            }

            if (dllCapNhatTrangThai.SelectedValue == "3")//Chuyển

            {
                lblNgayGiao.Text = "Ngày chuyển";

                if (TRANGTHAI_LICHSU_CURRENT != "1")//Trạng thái lịch sử là phiếu mượn
                {
                    txtTenNguoiNhan.Text = "";
                }


                try
                {
                    var SESSION_CANBOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID]);
                    ddlNguoichuyen.SelectedValue = "" + SESSION_CANBOID;
                }
                catch (Exception)
                {

                }

            }




        }

        protected void dllCapNhatTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadEnableControl();




            try
            {
                var SESSION_CANBOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID]);
                ddlNguoichuyen.SelectedValue = "" + SESSION_CANBOID;
            }
            catch (Exception)
            {

            }
        }

        protected void ddlLyDo_SelectedIndexChanged(object sender, EventArgs e)
        {
            showHideTextLyDo();
        }


        private void showHideTextLyDo()
        {
            txtLyDo.Visible = false;
            var lydo = ddlLyDo.SelectedValue;
            if (lydo == "-1") //lý do khác
            {
                txtLyDo.Visible = true;
            }
        }
        protected void cmdCapnhat_Click(object sender, EventArgs e)
        {
            lbthongBaoUpdate.Text = "";

            var TrangThai = int.Parse(dllCapNhatTrangThai.SelectedValue);

            #region Validate Data

            if (TrangThai == 0 || TrangThai == 1)
            {

            }
            else
            {


                if (Cls_Comon.IsValidDate(txtNgaygiao.Text) == false)
                {
                    lbthongBaoUpdate.Text = "Bạn phải nhập ngày nhận theo định dạng (dd/MM/yyyy)!";
                    txtNgaygiao.Focus();
                    return;
                }

                if (TrangThai != 2)
                {
                    if (ddlNguoichuyen.SelectedValue == "0")
                    {
                        lbthongBaoUpdate.Text = "Bạn chưa chọn Người giao Hồ sơ. Hãy chọn lại!";
                        ddlNguoichuyen.Focus();
                        return;
                    }
                }


                if (txtSoBuLuc.Text.Length <= 0)
                {
                    lbthongBaoUpdate.Text = "Bạn chưa nhập số bút lục. Hãy chọn lại!";
                    txtSoBuLuc.Focus();
                    return;
                }

            }
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
            var LoaiDonVi = decimal.Parse("0" + rbLoaiDonVi.SelectedValue);
            if (LoaiDonVi == 1 && LoaiDonVi == 2)
            {
                if (string.IsNullOrEmpty(ddDonViNhan.SelectedValue) || ddDonViNhan.SelectedValue == "0")
                {
                    lbthongBaoUpdate.Text = "Bạn chưa chọn đơn vị!";
                    return;
                }
            }




            //Cập nhật LichSu


            var strlichSuID = hddLichSuID.Value;
            if (!string.IsNullOrEmpty(strlichSuID) && decimal.Parse("0" + strlichSuID) > 0)
            {
                var lichSuID = decimal.Parse("0" + strlichSuID);
                var otLichSu = dt.QLHS_STPT_LICHSU.Where(t => t.ID == lichSuID).FirstOrDefault();
                if (otLichSu != null)
                {

                    otLichSu.NGUOICHOMUONID = Convert.ToDecimal(ddlNguoichuyen.SelectedValue);
                    otLichSu.TENNGUOICHOMUON = ddlNguoichuyen.SelectedItem.Text;
                    otLichSu.LOAITOAAN = LoaiDonVi;
                    if (TrangThai != 2)
                    {
                        otLichSu.NGUOICHOMUONID = Convert.ToDecimal(ddlNguoichuyen.SelectedValue);
                        otLichSu.TENNGUOICHOMUON = ddlNguoichuyen.SelectedItem.Text;
                    }


                    otLichSu.TENNGUOIMUON = txtTenNguoiNhan.Text;
                    if (dllCapNhatTrangThai.SelectedValue == "1")//Nhân hồ sơ 
                    {
                        otLichSu.TENNGUOIMUON = ddlNguoichuyen.SelectedItem.Text;
                    }


                    otLichSu.DONVIID = null;
                    otLichSu.DONVIMUON = "";
                    if (!string.IsNullOrEmpty(ddDonViNhan.SelectedValue) && ddDonViNhan.SelectedValue != "0")
                    {
                        otLichSu.DONVIID = Convert.ToDecimal(ddDonViNhan.SelectedValue);
                        otLichSu.DONVIMUON = ddDonViNhan.SelectedItem.Text;
                    }

                    if (LoaiDonVi == 2)//khác
                    {
                        otLichSu.DONVIID = 0;
                        otLichSu.DONVIMUON = txtDonViNhan.Text;
                    }

                    if (dllCapNhatTrangThai.SelectedValue == "1")//Nhân hồ sơ 
                    {
                        if (!string.IsNullOrEmpty(ddDonViNhan.SelectedValue) && ddDonViNhan.SelectedValue != "0")
                        {
                            //otLichSu.NGUOICHOMUONID = Convert.ToDecimal(ddDonViNhan.SelectedValue);
                            //otLichSu.TENNGUOICHOMUON = ddDonViNhan.SelectedItem.Text;

                            otLichSu.NGUOICHOMUONID = Convert.ToDecimal(ddDonViNhan.SelectedValue);
                            otLichSu.TENNGUOICHOMUON = ddDonViNhan.SelectedItem.Text;
                        }
                        if (LoaiDonVi == 2)//khác
                        {

                            otLichSu.NGUOICHOMUONID = 0;
                            otLichSu.TENNGUOICHOMUON = txtDonViNhan.Text;
                        }

                        //người nhận là người chuyển 
                        otLichSu.NGUOICHOMUONID = Convert.ToDecimal(ddlNguoichuyen.SelectedValue);
                        otLichSu.TENNGUOIMUON = txtTenNguoiNhan.Text;
                        otLichSu.TENNGUOICHOMUON = ddlNguoichuyen.SelectedItem.Text;
                    }
                    otLichSu.GHICHU = txtGQGhichu.Text;

                    otLichSu.NGAYTAO = DateTime.Now;

                    otLichSu.SOBUTLUC = Convert.ToDecimal(txtSoBuLuc.Text);
                    otLichSu.NGAYGIAONHAN = txtNgaygiao.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaygiao.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                    if (dllCapNhatTrangThai.SelectedValue == "1")//Nhận hồ sơ 
                    {
                        //cập nhật lại số bút lục
                        var OT = dt.QLHS_STPT.Where(t => t.ID == otLichSu.MAHS).FirstOrDefault();
                        if (OT != null)
                        {
                            OT.KHOLUUTRU = txtKhoLuuTru.Text;
                            OT.KHUNGLUUTRU = txtKhungLuuTru.Text;
                            OT.PHONGLUUTRU = txtPhongLuuTru.Text;
                            OT.SOGIA = txtSoGia.Text;
                            OT.SOHOP = txtSoHop.Text;
                            OT.SOQUYEN = txtSoQuyen.Text;
                            OT.SOBUTLUC = Convert.ToDecimal(txtSoBuLuc.Text);
                            OT.NGAYSUA = DateTime.Now;
                        }

                        otLichSu.KHOLUUTRU = txtKhoLuuTru.Text;
                        otLichSu.KHUNGLUUTRU = txtKhungLuuTru.Text;
                        otLichSu.PHONGLUUTRU = txtPhongLuuTru.Text;
                        otLichSu.SOGIA = txtSoGia.Text;
                        otLichSu.SOHOP = txtSoHop.Text;
                        otLichSu.SOQUYEN = txtSoQuyen.Text;
                    }

                    dt.SaveChanges();
                    Load_Data(otLichSu.MAHS ?? 0);
                    TRANGTHAI = dllCapNhatTrangThai.SelectedValue;

                    LoadTrangThai();
                    LoadLyDo();


                    //Literal lt1 = new Literal();
                    ////lt.Text = "<script>window.opener.location.replace('/QLAN/QLHS/QuanlyMuonTra.aspx');alert('" + strMsg + "');window.close();</script>";
                    //lt1.Text = "<script>alert('Cập nhật thành công');</script>";
                    //this.Page.Controls.Add(lt1);
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent()");
                    lbthongBaoUpdate.Text = "Cập nhật thành công";

                    reSetControl();

                    lbthongBaoUpdate.Text = "Cập nhật thành công";
                    return;
                }
                else
                {
                    lbthongBaoUpdate.Text = "Không có thông tin để cập nhật";

                    return;
                }


            }

            //
            decimal IDVuViec = Convert.ToDecimal(hddVuViecID.Value);
            var LOAIAN = decimal.Parse(hddLoaiAn.Value);
            var Capxx = decimal.Parse(hddCapxx.Value);











            QLHS_STPT oT = dt.QLHS_STPT.Where(x => x.VUVIECID == IDVuViec && x.LOAIAN == LOAIAN && x.CAPXX == Capxx).FirstOrDefault();

            if (oT == null)
            {
                lbthongBaoUpdate.Text = "Chưa lưu thông tin hồ sơ";
                txtSoBuLuc.Focus();
                return;
            }
            var lichsuCuoi = dt.QLHS_STPT_LICHSU.Where(x => x.MAHS == oT.ID).OrderByDescending(t => t.ID).FirstOrDefault();



            var TrangThaiLichSuHienTai = 1;

            if (TrangThai == 1) //cập nhật Lưu trữ và nhận lại hồ sơ
            {
                TrangThaiLichSuHienTai = 3;
            }
            if (TrangThai == 2) //cập nhật Phiếu mượn
            {
                TrangThaiLichSuHienTai = 1;
            }
            if (TrangThai == 3) //Phiếu chuyển
            {
                TrangThaiLichSuHienTai = 2;
            }

            //Nếu insert vào là lịch sử cũ thì ko cho insert
            //Nếu là trạng thái cuối cùng là phiếu chuyển mà trạng thái mà ko phải là phiếu nhận về  thì ko cho cập nhật
            if (lichsuCuoi != null && lichsuCuoi.TRANGTHAIID == 2 && TrangThaiLichSuHienTai != 3)
            {
                lbthongBaoUpdate.Text = "Hồ sơ đang cho chuyển đơn vị: " + lichsuCuoi.DONVIMUON + ", Bạn phải không tạo phiếu được";
                txtSoBuLuc.Focus();
                return;
            }





            //Nếu mà trạng thái  mới và đã lưu thì chỉ cập nhật trạng thái 


            oT.LOAITOAAN = LoaiDonVi;
            oT.NGAYGIAONHAN = txtNgaygiao.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaygiao.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            // oT.NGUOINHANID = Convert.ToDecimal(ddNguoinhan.SelectedValue);
            oT.TENNGUOINHAN = txtTenNguoiNhan.Text;

            oT.NGUOICHUYENID = Convert.ToDecimal(ddlNguoichuyen.SelectedValue);
            oT.TENNGUOICHUYEN = ddlNguoichuyen.SelectedItem.Text;

            if (TrangThai != 2)
            {
                oT.NGUOICHUYENID = Convert.ToDecimal(ddlNguoichuyen.SelectedValue);
                oT.TENNGUOICHUYEN = ddlNguoichuyen.SelectedItem.Text;
            }

            oT.DONVIID = null;
            oT.TENDONVI = "";
            if (!string.IsNullOrEmpty(ddDonViNhan.SelectedValue) && ddDonViNhan.SelectedValue != "0")
            {
                oT.DONVIID = Convert.ToDecimal(ddDonViNhan.SelectedValue);
                oT.TENDONVI = ddDonViNhan.SelectedItem.Text;
            }


            oT.SOBUTLUC = Convert.ToDecimal(txtSoBuLuc.Text);
            oT.GHICHU = txtGQGhichu.Text;

            oT.NGUOISUA = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            oT.NGAYSUA = DateTime.Now;

            //Sửa lại nghiệp vụ nếu hồ sơ mượn thì vẫn là trạng thái Nhận hồ sơ
            if (TrangThai == 2)
            {
                oT.TRANGTHAIID = 1;
            }
            else
                oT.TRANGTHAIID = TrangThai;


            oT.KHOLUUTRU = txtKhoLuuTru.Text;
            oT.KHUNGLUUTRU = txtKhungLuuTru.Text;
            oT.PHONGLUUTRU = txtPhongLuuTru.Text;
            oT.SOGIA = txtSoGia.Text;
            oT.SOHOP = txtSoHop.Text;
            oT.SOQUYEN = txtSoQuyen.Text;

            //if (LoaiDonVi == 1)//Viện kiế xoát
            //{
            //    oT.DONVIID = Convert.ToDecimal(ddDonViNhan.SelectedValue);
            //    oT.TENDONVI = ddDonViNhan.SelectedItem.Text;
            //}

            if (LoaiDonVi == 2)//khác
            {
                oT.DONVIID = 0;
                oT.TENDONVI = txtDonViNhan.Text;
            }

            if (dllCapNhatTrangThai.SelectedValue == "1")//Nhân hồ sơ 
            {
                //if (!string.IsNullOrEmpty(ddDonViNhan.SelectedValue) && ddDonViNhan.SelectedValue != "0")
                //{
                //    oT.NGUOICHUYENID = Convert.ToDecimal(ddDonViNhan.SelectedValue);
                //    oT.TENNGUOICHUYEN = ddDonViNhan.SelectedItem.Text;
                //}
                //if (LoaiDonVi == 2)//khác
                //{

                //    oT.NGUOICHUYENID = 0;
                //    oT.TENNGUOICHUYEN = txtDonViNhan.Text;
                //}


                if (!string.IsNullOrEmpty(ddDonViNhan.SelectedValue) && ddDonViNhan.SelectedValue != "0")
                {
                    oT.DONVIID = Convert.ToDecimal(ddDonViNhan.SelectedValue);
                    oT.TENDONVI = ddDonViNhan.SelectedItem.Text;
                }
                if (LoaiDonVi == 2)//khác
                {
                    oT.DONVIID = 0;
                    oT.TENDONVI = txtDonViNhan.Text;

                    //oT.NGUOICHUYENID = 0;
                    //oT.TENNGUOICHUYEN = txtDonViNhan.Text;
                }

                //người nhận là người chuyển 
                oT.NGUOICHUYENID = Convert.ToDecimal(ddlNguoichuyen.SelectedValue);
                oT.TENNGUOICHUYEN = txtTenNguoiNhan.Text;
                oT.TENNGUOINHAN = ddlNguoichuyen.SelectedItem.Text;



            }




            if (oT.ID > 0)
            {
                var TrangThaiLichSu = 1;
                //1:Cho muon; 2:Phiếu chuyển; 3: Tra HS
                //1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên, 4: có kháng cáo
                var check = true;

                if (TrangThai == 1) //cập nhật Lưu trữ và nhận lại hồ sơ
                {
                    TrangThaiLichSu = 3;
                }
                if (TrangThai == 2) //cập nhật Phiếu mượn
                {
                    TrangThaiLichSu = 1;
                }
                if (TrangThai == 3) //Phiếu chuyển
                {
                    TrangThaiLichSu = 2;
                }



                //
                decimal? TrangThaiLichSu_Cu = 0;
                var lichsu = dt.QLHS_STPT_LICHSU.Where(x => x.MAHS == oT.ID).OrderByDescending(t => t.ID).FirstOrDefault();
                if (lichsu != null)
                {
                    TrangThaiLichSu_Cu = lichsu.TRANGTHAIID;
                }

                //Nếu insert vào là lịch sử cũ thì ko cho insert
                if (TrangThaiLichSu_Cu == TrangThaiLichSu)
                {
                    check = false;
                }

                if (TrangThaiLichSu == 1) //Trạng thái là cho mượn thì insert thoải mái
                {
                    check = true;
                }

                if (check)
                {
                    //Insert vào lich su
                    QLHS_STPT_LICHSU otLichSu = new QLHS_STPT_LICHSU()
                    {
                        MAHS = oT.ID,
                        TRANGTHAIID = TrangThaiLichSu,
                        NGUOICHOMUONID = oT.NGUOICHUYENID,
                        TENNGUOICHOMUON = oT.TENNGUOICHUYEN,
                        NGUOIMUONID = oT.NGUOINHANID,
                        TENNGUOIMUON = oT.TENNGUOINHAN,

                        LOAITOAAN = LoaiDonVi,
                        DONVIID = oT.DONVIID,
                        DONVIMUON = oT.TENDONVI,

                        KHOLUUTRU = txtKhoLuuTru.Text,
                        KHUNGLUUTRU = txtKhungLuuTru.Text,
                        PHONGLUUTRU = txtPhongLuuTru.Text,
                        SOGIA = txtSoGia.Text,
                        SOHOP = txtSoHop.Text,
                        SOQUYEN = txtSoQuyen.Text,

                        SOBUTLUC = oT.SOBUTLUC,
                        GHICHU = oT.GHICHU,
                        NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + ""),
                        NGAYTAO = DateTime.Now,
                        NGAYGIAONHAN = oT.NGAYGIAONHAN
                    };

                    if (TrangThai == 3) //Phiếu chuyển
                    {
                        otLichSu.LYDOID = Convert.ToDecimal(ddlLyDo.SelectedValue);
                        otLichSu.TENLYDO = ddlLyDo.SelectedItem.Text;

                        if (ddlLyDo.SelectedValue == "-1")
                        {
                            otLichSu.LYDOID = null;
                            otLichSu.TENLYDO = txtLyDo.Text;
                        }
                    }

                    dt.QLHS_STPT_LICHSU.Add(otLichSu);
                }



            }
            dt.SaveChanges();



            Load_Data(oT.ID);
            TRANGTHAI = dllCapNhatTrangThai.SelectedValue;

            LoadTrangThai();
            LoadLyDo();

            //var strMsg = "Cập nhật thành công";
            //Literal lt = new Literal();
            ////lt.Text = "<script>alert('" + strMsg + "');setTimeout(function(){  window.close(); }, 2000); </script>";
            //lt.Text = "<script>alert('" + strMsg + "');</script>";
            //this.Page.Controls.Add(lt);

            //Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent()");
            lbthongBaoUpdate.Text = "Cập nhật thành công";

            reSetControl();

            lbthongBaoUpdate.Text = "Cập nhật thành công";

        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {

            try
            {
                Literal lt = new Literal();

                //lt.Text = "<script>window.close();</script>";

                // lt.Text = "<script>window.opener.location.replace('/QLAN/QLHS/Quanlymuontra.aspx');window.close();</script>";

                //this.Page.Controls.Add(lt);
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
        }


        public void Load_Data(decimal ID)
        {
            dgList.Visible = true;
            var lichsu = dt.QLHS_STPT_LICHSU.Where(t => t.MAHS == ID).OrderByDescending(t => t.NGAYGIAONHAN).ThenByDescending(t => t.ID).ToList().Select(t => new QLHS_STPT_LICHSU_CUSTOM()
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
                NGAYGIAONHAN = t.NGAYGIAONHAN,
                STRNGAYGIAONHAN = t.NGAYGIAONHAN.HasValue ? t.NGAYGIAONHAN.Value.ToString("dd/MM/yyyy") : "",
                TENLYDO = t.TENLYDO
            }).ToList();


            if (lichsu.Count == 0)
            {
                cmd_exels.Visible = false;
            }

            //1:Cho muon; 2:Phiếu chuyển; 3: Tra HS
            for (int i = 0; i < lichsu.Count; i++)
            {
                if (lichsu[i].TRANGTHAIID == 1)
                {
                    lichsu[i].TENTRANGTHAI = "Phiếu mượn";
                }
                if (lichsu[i].TRANGTHAIID == 2)
                {
                    lichsu[i].TENTRANGTHAI = "Phiếu chuyển";
                }
                if (lichsu[i].TRANGTHAIID == 3)
                {
                    lichsu[i].TENTRANGTHAI = "Nhận hồ sơ";
                }
            }

            dgList.DataSource = lichsu;
            dgList.DataBind();
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            try
            {
                reSetControl();
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
        }
        private void reSetControl()
        {
            Response.Redirect(Request.RawUrl, true);
        }
        public void loadedit(int ID)
        {
            var lichSu = dt.QLHS_STPT_LICHSU.Where(x => x.ID == ID).FirstOrDefault();
            if (lichSu != null)
            {
                dllCapNhatTrangThai.Enabled = false;
                hddLichSuID.Value = "" + ID;
                MAHOSO = lichSu.MAHS ?? 0;

                


                txtSoBuLuc.Text = "" + lichSu.SOBUTLUC;
                txtGQGhichu.Text = lichSu.GHICHU;

                rbLoaiDonVi.SelectedValue = "" + (lichSu.LOAITOAAN ?? 0);




                txtKhoLuuTru.Text = lichSu.KHOLUUTRU;
                txtKhungLuuTru.Text = lichSu.KHUNGLUUTRU;
                txtPhongLuuTru.Text = lichSu.PHONGLUUTRU;
                txtSoGia.Text = lichSu.SOGIA;
                txtSoHop.Text = lichSu.SOHOP;
                txtSoQuyen.Text = lichSu.SOQUYEN;

                //Trạng thái


                if (lichSu.TRANGTHAIID == 3) //cập nhật Lưu trữ và nhận lại hồ sơ
                {
                    TRANGTHAI = "" + 1;
                }
                if (lichSu.TRANGTHAIID == 1) //cập nhật Phiếu mượn
                {
                    TRANGTHAI = "" + 2;
                }
                if (lichSu.TRANGTHAIID == 2) //Phiếu chuyển
                {
                    TRANGTHAI = "" + 3;
                }


                //Trạng thái


                LoadTrangThai(2);
                LoadLyDo();



                LoadDonViNhan();

                LoadEnableControl();
                LoadNguoiChuyen();


                if (lichSu.DONVIID == 0)
                {
                    txtDonViNhan.Text = lichSu.DONVIMUON;
                }
                if ("" + (lichSu.LOAITOAAN ?? 2) != "2" && (lichSu.DONVIID ?? 0) > 0)
                {
                    ddDonViNhan.SelectedValue = "" + (lichSu.DONVIID ?? 0);

                }
                else
                {
                    txtDonViNhan.Text = lichSu.DONVIMUON;
                }
                if (lichSu.DONVIID == 0)
                {
                    txtDonViNhan.Text = lichSu.DONVIMUON;
                }
                if (lichSu.NGUOICHOMUONID.HasValue)
                {
                    ddlNguoichuyen.SelectedValue = "" + lichSu.NGUOICHOMUONID;
                }
                else ddlNguoichuyen.SelectedValue = "0";

                txtLyDo.Text = lichSu.TENLYDO;


                if (lichSu.LYDOID.HasValue && lichSu.LYDOID > 0)
                {
                    ddlLyDo.SelectedValue = "" + lichSu.LYDOID;
                }
                txtTenNguoiNhan.Text = "" + lichSu.TENNGUOIMUON;
            }

        }
        public void xoaLichSu(int id)
        {
            var obj = dt.QLHS_STPT_LICHSU.Where(x => x.ID == id).FirstOrDefault();




            if (obj != null)
            {

                dt.QLHS_STPT_LICHSU.Remove(obj);



                dt.SaveChanges();

                Load_Data(obj.MAHS ?? 0);

                try
                {
                    var MAHOSO = obj.MAHS;
                    var lstHoSoChiTiet = dt.QLHS_STPT_LICHSU.Where(x => x.MAHS == MAHOSO).OrderByDescending(t => t.NGAYGIAONHAN).ThenByDescending(t=>t.ID).ToList();

                    //Nếu mà hố sơ  = 0 thì mặc định là lưu hồ sơ, nếu lớn hơn 1 thì lấy bản ghi cuối cùng

                    var TRANGTHAI_UPDATE = 0;

                    if (lstHoSoChiTiet != null && lstHoSoChiTiet.Count > 0)
                    {
                        var TRANGTHAI_LICHSU = lstHoSoChiTiet.FirstOrDefault().TRANGTHAIID;


                        if (TRANGTHAI_LICHSU == 3) //cập nhật Lưu trữ và nhận lại hồ sơ
                        {
                            TRANGTHAI_UPDATE = 1;
                        }
                        if (TRANGTHAI_LICHSU == 1) //cập nhật Phiếu mượn
                        {
                            TRANGTHAI_UPDATE = 1;
                        }
                        if (TRANGTHAI_LICHSU == 2) //Phiếu chuyển
                        {
                            TRANGTHAI_UPDATE = 3;
                        }
                        else TRANGTHAI_UPDATE = 1;


                    }
                    else
                    {
                        TRANGTHAI_UPDATE = 1;
                    }


                    var hoso = dt.QLHS_STPT.Where(t => t.ID == MAHOSO).FirstOrDefault();
                    if (hoso != null)
                    {
                        hoso.TRANGTHAIID = TRANGTHAI_UPDATE;
                        hoso.NGAYSUA = DateTime.Now;
                    }

                    dt.SaveChanges();
                }
                catch
                {


                }


                lbthongBaoUpdate.Text = "Xóa thành công!";
            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Panel pn_ChoMuon = (Panel)e.Item.FindControl("pn_ChoMuon");
                Panel pn_Chuyen = (Panel)e.Item.FindControl("pn_Chuyen");
                Panel pn_NhanHoSo = (Panel)e.Item.FindControl("pn_NhanHoSo");

                pn_ChoMuon.Visible = false;
                pn_Chuyen.Visible = false;
                pn_NhanHoSo.Visible = false;
                //<% ---1:Cho muon; 2:Hồ sơ đã chuyển; 3: Tra HS ------%>
                String TRANGTHAIID = ((QLHS_STPT_LICHSU_CUSTOM)e.Item.DataItem).TRANGTHAIID.ToString();
                if (TRANGTHAIID == "1")
                {
                    pn_ChoMuon.Visible = true;
                }
                if (TRANGTHAIID == "2")
                {
                    pn_Chuyen.Visible = true;
                }
                if (TRANGTHAIID == "3")
                {
                    pn_NhanHoSo.Visible = true;
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                int LichSuID = Convert.ToInt32(e.CommandArgument.ToString());
                lbthongBaoUpdate.Text = "";
                switch (e.CommandName)
                {
                    case "Sua":
                        loadedit(LichSuID);
                        hddLichSuID.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        // chỉ load lại danh sách các control phía trên giữ nguyên

                        xoaLichSu(LichSuID);

                        break;
                }
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
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
            var lichsu = dt.QLHS_STPT_LICHSU.Where(t => t.MAHS == MAHOSO).OrderByDescending(t => t.NGAYGIAONHAN).ThenByDescending(t => t.ID).ToList().Select(t => new QLHS_STPT_LICHSU_CUSTOM()
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
                STRNGAYGIAONHAN = t.NGAYGIAONHAN.HasValue ? t.NGAYGIAONHAN.Value.ToString("dd/MM/yyyy") : "",
                TENLYDO = t.TENLYDO
            }).ToList();


            QLHS_STPT qLHS_STPT = dt.QLHS_STPT.FirstOrDefault(s => s.ID == MAHOSO);
            string TenVuAn="";
            if (qLHS_STPT.LOAIAN == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU))
            {
                ADS_DON don = dt.ADS_DON.FirstOrDefault(s => s.ID == qLHS_STPT.VUVIECID);
                TenVuAn = don.TENVUVIEC;
                
            }
            else if (qLHS_STPT.LOAIAN == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH))
            {
                AHC_DON don = dt.AHC_DON.FirstOrDefault(s => s.ID == qLHS_STPT.VUVIECID);
                TenVuAn = don.TENVUVIEC;
            }
            else if (qLHS_STPT.LOAIAN == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH))
            {
                AHN_DON don = dt.AHN_DON.FirstOrDefault(s => s.ID == qLHS_STPT.VUVIECID);
                TenVuAn = don.TENVUVIEC;
            }
            else if (qLHS_STPT.LOAIAN == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI))
            {
                AKT_DON don = dt.AKT_DON.FirstOrDefault(s => s.ID == qLHS_STPT.VUVIECID);
                TenVuAn = don.TENVUVIEC;

            }
            else if (qLHS_STPT.LOAIAN == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG))
            {
                ALD_DON don = dt.ALD_DON.FirstOrDefault(s => s.ID == qLHS_STPT.VUVIECID);
                TenVuAn = don.TENVUVIEC;
            }
            else if (qLHS_STPT.LOAIAN == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN))
            {
                APS_DON don = dt.APS_DON.FirstOrDefault(s => s.ID == qLHS_STPT.VUVIECID);
                TenVuAn = don.TENVUVIEC;
            }
            else if (qLHS_STPT.LOAIAN == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU))
            {
                AHS_VUAN don = dt.AHS_VUAN.FirstOrDefault(s => s.ID == qLHS_STPT.VUVIECID);
                TenVuAn = don.TENVUAN;
            }


            //1:Cho muon; 2:Hồ sơ đã chuyển; 3: Tra HS
            for (int i = 0; i < lichsu.Count; i++)
            {
                if (lichsu[i].TRANGTHAIID == 1)
                {
                    lichsu[i].TENTRANGTHAI = "Phiếu mượn";
                }
                if (lichsu[i].TRANGTHAIID == 2)
                {
                    lichsu[i].TENTRANGTHAI = "Phiếu chuyển";
                }
                if (lichsu[i].TRANGTHAIID == 3)
                {
                    lichsu[i].TENTRANGTHAI = "Nhận hồ sơ";
                }
            }

            var html = "";
            html = html + @"<table cellpadding='0' cellspacing='1' style='font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;'>";
            html = html + @"<tr class='header'>";
            html = html + @" </tr>";
            html = html + @"<tr class='header'>";
            html = html + @"<td colspan='5' style='font-family: sans-serif;line-height: 100%; font-size: 14pt; text-align: center; height: 80px;'><b>Vụ án: " + TenVuAn + "" + (string.IsNullOrEmpty(SOBANAN) ? "" : "<br/>Bản án số: " + SOBANAN) + "" + (string.IsNullOrEmpty(NGAYBANAN) ? "" : " ngày " + NGAYBANAN) + "</b></td>";
            html = html + @" </tr>";;
            html = html + @"<tr class='header'>";
            html = html + @" <th colspan='1' style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>TT</th>";
            html = html + @"   <th colspan='1' style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Trạng thái</th>";
            html = html + @"   <th colspan='3' style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Thông tin</th>";

            html = html + @" </tr>";


            for (int i = 0; i < lichsu.Count; i++)
            {



                html = html + @"<tr class='chan'>";
                html = html + @" <td colspan='1' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + (i + 1) + "</td>";
                html = html + @"   <td colspan='1' style='border: 0.1pt solid Black; text-align: left; vertical-align: middle;'> " + lichsu[i].TENTRANGTHAI + "  </td>";


                if (lichsu[i].TRANGTHAIID == 1)
                {

                    html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: left; vertical-align: middle;width:700px;'>Đơn vị nhận: " + lichsu[i].DONVIMUON +
                        " <br style='mso-data-placement:same-cell;' />Người nhận: " + lichsu[i].TENNGUOIMUON +
                        " <br style='mso-data-placement:same-cell;' />Ngày chuyển: " + lichsu[i].STRNGAYGIAONHAN +
                        " <br style='mso-data-placement:same-cell;' />Số phiếu: " + lichsu[i].SOBUTLUC +
                        " <br style='mso-data-placement:same-cell;' />Ghi chú: " + lichsu[i].GHICHU + " </td>";

                }
                if (lichsu[i].TRANGTHAIID == 2)
                {

                    html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: left; vertical-align: middle;width:700px;'>Đơn vị nhận: " + lichsu[i].DONVIMUON + " <br style='mso-data-placement:same-cell;' />Người nhận: " + lichsu[i].TENNGUOIMUON + " <br style='mso-data-placement:same-cell;' />Ngày chuyển: " + lichsu[i].STRNGAYGIAONHAN + " <br style='mso-data-placement:same-cell;' />Số phiếu: " + lichsu[i].SOBUTLUC + " <br style='mso-data-placement:same-cell;' />Tên lý do: " + lichsu[i].TENLYDO + " <br style='mso-data-placement:same-cell;' />Ghi chú: " + lichsu[i].GHICHU + " </td>";

                }
                if (lichsu[i].TRANGTHAIID == 3)
                {
                    html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: left; vertical-align: middle;width:700px;'>Đơn vị trả: " + lichsu[i].DONVIMUON +
                        " <br style='mso-data-placement:same-cell;' />Người trả: " + lichsu[i].TENNGUOIMUON +
                        " <br style='mso-data-placement:same-cell;' />Ngày nhận: " + lichsu[i].STRNGAYGIAONHAN +
                        " <br style='mso-data-placement:same-cell;' />Số phiếu: " + lichsu[i].SOBUTLUC +
                        " <br style='mso-data-placement:same-cell;' />Kho lưu trữ: " + lichsu[i].KHOLUUTRU


                        + " <br style='mso-data-placement:same-cell;' />Khung lưu trữ: " + lichsu[i].KHUNGLUUTRU
                        + " <br style='mso-data-placement:same-cell;' />Phông lưu trữ: " + lichsu[i].PHONGLUUTRU
                        + " <br style='mso-data-placement:same-cell;' />Số giá: " + lichsu[i].SOGIA
                        + " <br style='mso-data-placement:same-cell;' />Số hộp: " + lichsu[i].SOHOP
                          + " <br style='mso-data-placement:same-cell;' />Số cặp/quyển: " + lichsu[i].SOQUYEN

                        + " <br style='mso-data-placement:same-cell;' />Ghi chú: " + lichsu[i].GHICHU + " </td>";
                }




                //html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].DONVIMUON + "</td>";
                //html = html + @" <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'> " + lichsu[i].TENNGUOIMUON + "</td>";

                //html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'> " + lichsu[i].TENNGUOICHOMUON + "</td>";
                //html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].SOBUTLUC + "</td> ";
                //html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].KHOLUUTRU + "</td> ";
                //html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].KHUNGLUUTRU + "</td> ";
                //html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].PHONGLUUTRU + "</td> ";
                //html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].SOGIA + "</td> ";
                //html = html + @"  <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].SOHOP + "</td> ";
                //html = html + @"   <td colspan='3' style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + lichsu[i].SOQUYEN + "</td> ";

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
            public Nullable<System.DateTime> NGAYGIAONHAN { get; set; }
            public string STRNGAYGIAONHAN { get; set; }
            public Nullable<decimal> LOAITOAAN { get; set; }
            public string KHOLUUTRU { get; set; }
            public string KHUNGLUUTRU { get; set; }
            public string PHONGLUUTRU { get; set; }
            public string SOGIA { get; set; }
            public string SOHOP { get; set; }
            public string SOQUYEN { get; set; }
            public string TENLYDO { get; set; }
        }
    }
}