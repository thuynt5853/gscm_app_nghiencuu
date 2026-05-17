using BL.GSTP;
using BL.GSTP.AHN;
using BL.GSTP.BANGSETGET;
using BL.GSTP.QLAN;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Configuration;
using Aspose.Words;
using Aspose.Cells;
using System.IO;

namespace WEB.GSTP.QLAN.KHANGCAOQUAHAN
{
    public partial class Capnhatkhangcaoquahan_AHN : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        private decimal LOAIAN = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH);

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdInDanhsach);
            scriptManager.RegisterPostBackControl(this.cmdInQuyetdinh);

            try
            {
                if (!IsPostBack)
                {
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    Load_ddlTimkiem_Thamphan();
                    Load_ddlTimkiem_Thuky();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void Load_ddlTimkiem_Thamphan()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable oCBDT = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(DonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlTimkiem_Thamphan.DataSource = oCBDT;
            ddlTimkiem_Thamphan.DataTextField = "HOTEN";
            ddlTimkiem_Thamphan.DataValueField = "ID";
            ddlTimkiem_Thamphan.DataBind();
            ddlTimkiem_Thamphan.Items.Insert(0, new ListItem("-- Tất cả --", "0"));
            ddlTimkiem_Thamphan.Text = "Tên thẩm phán";
        }
        private void Load_ddlTimkiem_Thuky()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            ddlTimkiem_Thuky.Items.Clear();
            tbl = objBL.DM_CANBO_GetAllThuKy_TTV(DonViID, ENUM_CHUCDANH.CHUCDANH_THUKY);
            ddlTimkiem_Thuky.DataSource = tbl;
            ddlTimkiem_Thuky.DataTextField = "HOTEN_CHUCDANH";
            ddlTimkiem_Thuky.DataValueField = "ID";
            ddlTimkiem_Thuky.DataBind();
            ddlTimkiem_Thuky.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));
            ddlTimkiem_Thuky.Text = "Thư ký phiên tòa";
        }
        private void LoadGrid()
        {
            lbthongbao.Text = "";
            ptT.Visible = ptB.Visible = true;

            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            int pageSize = dgList.PageSize, pageIndex = Convert.ToInt32(hddPageIndex.Value);

            STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();
            DataTable oDT = oBL.AHN_PT_KCQUAHAN(LOAIAN, vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtTimkiem_SoBAQD.Text, txtTimkiem_NgayBAQD.Text, txtTimkiem_NguoiKC.Text, txtTuNgay.Text, txtDenNgay.Text,
                                                txtTimkiem_SoTL.Text, txtTimkiem_TuNgayTL.Text, txtTimkiem_DenNgayTL.Text, Convert.ToDecimal(ddlTimkiem_Trangthai.SelectedValue + ""), txtTrangthai_tungay.Text, txtTrangthai_denngay.Text, Convert.ToDecimal(ddlTimkiem_Thamphan.SelectedValue + ""), Convert.ToDecimal(ddlTimkiem_Thuky.SelectedValue + ""),
                                                "", pageIndex, pageSize);




            // , dFrom, dTo, Convert.ToDecimal(ddlTimkiem_Trangthai.SelectedValue), pageIndex, pageSize);

            int Total = 0;
            if (oDT != null && oDT.Rows.Count > 0)
            {
                Total = Convert.ToInt32(oDT.Rows[0]["CountAll"]);
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            }

            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            dgList.DataSource = oDT;
            dgList.DataBind();
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                #region Validate
                if (txtTuNgay.Text != "" && Cls_Comon.IsValidDate(txtTuNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập kháng cáo từ ngày theo định dạng (dd/MM/yyyy)!";
                    txtTuNgay.Focus();
                    return;
                }
                if (txtDenNgay.Text != "" && Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập kháng cáo đến ngày theo định dạng (dd/MM/yyyy)!";
                    txtDenNgay.Focus();
                    return;
                }
                if (txtTuNgay.Text != "" && txtDenNgay.Text != "")
                {
                    DateTime TuNgay = DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    DateTime DenNgay = DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (DateTime.Compare(TuNgay, DenNgay) > 0)
                    {
                        lbthongbao.Text = "Bạn phải nhập ngày kháng cáo từ ngày phải nhỏ hơn đến ngày!";
                        txtDenNgay.Focus();
                        return;
                    }
                }
                #endregion
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lbtGiaiquyet = (LinkButton)e.Item.FindControl("lbtGiaiquyet");
                Cls_Comon.SetLinkButton(lbtGiaiquyet, oPer.CAPNHAT);

                LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                Cls_Comon.SetLinkButton(lbtSua, oPer.CAPNHAT);

                decimal DONID = Convert.ToDecimal(rowView["ID"] + "");

                if (rowView["KETQUA"] + "" != "Chưa giải quyết")
                {
                    lbtGiaiquyet.Visible = false;
                    lbtSua.Visible = true;
                }
                else
                {
                    lbtGiaiquyet.Visible = true;
                    lbtSua.Visible = false;
                }

            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            hddKhangcaoID.Value = "0";
            hddVuViecID.Value = "0";
            hddThulyid.Value = "0";
            hddHdxxid.Value = "0";
            hddKetqua.Value = "0";

            decimal DONID = 0;
            string StrPara = "";
            StrPara = e.CommandArgument.ToString();
            if (StrPara.Contains(";#"))
            {
                string[] arr = StrPara.Split(';');
                DONID = Convert.ToDecimal(arr[0] + "");
                hddKhangcaoID.Value = arr[1].Replace("#", "") + "";
            }

            switch (e.CommandName)
            {

                case "Giaiquyet":
                    mp1.Show();
                    cmdGiaiQuyet_Click(DONID);
                    loadInfo(DONID);
                    loadThuly(DONID);
                    LoadGrid_HDXX();
                    loadKetqua(DONID);
                    break;
                case "Sua":
                    mp1.Show();
                    cmdGiaiQuyet_Click(DONID);
                    loadInfo(DONID);
                    loadThuly(DONID);
                    LoadGrid_HDXX();
                    loadKetqua(DONID);
                    break;
            }

        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {

        }
        protected void ddlTucachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string tucach = ddlTucachTGTT.SelectedValue;
            if (tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET)
            {

                ddlCanboHDXX.Items.Clear();
                tbl = objBL.DM_CANBO_GetAllThuKy_TTV(DonViID, ENUM_CHUCDANH.CHUCDANH_THUKY);
                ddlCanboHDXX.DataSource = tbl;
                ddlCanboHDXX.DataTextField = "HOTEN_CHUCDANH";
                ddlCanboHDXX.DataValueField = "ID";
                ddlCanboHDXX.DataBind();
                ddlCanboHDXX.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));
                lbCanboHDXX.Text = "Thư ký phiên tòa";
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanboHDXX.ClientID);
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND)
            {
                lbCanboHDXX.Text = "Tên Hội thẩm nhân dân";
                LoadDrop_CanBoVKS(ddlCanboHDXX);
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanboHDXX.ClientID);
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
            {
                lbCanboHDXX.Text = "Tên Kiểm sát viên";
                LoadDrop_CanBoVKS(ddlCanboHDXX);
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanboHDXX.ClientID);
            }
            else
            {
                DataTable oCBDT = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(DonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlCanboHDXX.Items.Clear();
                ddlCanboHDXX.DataSource = oCBDT;
                ddlCanboHDXX.DataTextField = "HOTEN";
                ddlCanboHDXX.DataValueField = "ID";
                ddlCanboHDXX.DataBind();
                ddlCanboHDXX.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
                lbCanboHDXX.Text = "Tên thẩm phán";
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanboHDXX.ClientID);
            }
        }
        protected void ddlTimkiem_Trangthai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlTimkiem_Trangthai.SelectedValue == "2") //Tìm kiếm theo “Tất cả” thì ẩn từ ngày đến ngày
            {
                txtTrangthai_tungay.Visible = false;
                MaskedEditValidator6.Visible = false;
                txtTrangthai_denngay.Visible = false;
                MaskedEditValidator7.Visible = false;
            }
            else
            {
                txtTrangthai_tungay.Visible = true;
                MaskedEditValidator6.Visible = true;
                txtTrangthai_denngay.Visible = true;
                MaskedEditValidator7.Visible = true;
            }

            if (ddlTimkiem_Trangthai.SelectedValue == "3") //Khi chọn “Chưa thụ lý” thì chỉ cho nhập “Đến ngày” ko cho chọn từ ngày
            {
                txtTrangthai_tungay.Enabled = false;
                txtTrangthai_tungay.Text = "";
            }
            else
            {
                txtTrangthai_tungay.Enabled = true;
            }
        }
        void LoadDrop_CanBoVKS(DropDownList drop)
        {
            String ma_loai_chucdanh = ddlTucachTGTT.SelectedValue;
            Decimal CurrDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_CANBOVKS_BL objBL = new DM_CANBOVKS_BL();
            DataTable tbl = objBL.DM_CANBOVKS_GETBYDONVI_LOAI(CurrDonViID, ma_loai_chucdanh);
            drop.Items.Clear();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                drop.DataSource = tbl;
                drop.DataTextField = "MA_TEN";
                drop.DataValueField = "ID";
                drop.DataBind();

                drop.Items.Insert(0, new ListItem("--Chọn--", "0"));
            }
            else
                drop.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }

        protected void cmdGiaiQuyet_Click(decimal DONID)
        {
            hddVuViecID.Value = DONID.ToString();
            if (hddVuViecID.Value + "" == "" || hddVuViecID.Value == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn vụ việc để giải quyết. Hãy chọn lại!";
                return;
            }
            loadDDLHDXX();
            loadDDLThuly();
        }
        protected void loadDDLHDXX()
        {
            ddlTucachTGTT.Items.Clear();
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán chủ tọa phiên tòa", ENUM_NGUOITIENHANHTOTUNG.THAMPHAN));
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_NGUOITIENHANHTOTUNG.THAMPHANHDXX));
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_NGUOITIENHANHTOTUNG.THAMPHANDUKHUYET));
            ddlTucachTGTT.Items.Add(new ListItem("Hội thẩm nhân dân", ENUM_CHUCDANH.CHUCDANH_HTND));
            ddlTucachTGTT.Items.Add(new ListItem("Thư ký", ENUM_NGUOITIENHANHTOTUNG.THUKY));
            ddlTucachTGTT.Items.Add(new ListItem("Thư ký dự khuyết", ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET));
            ddlTucachTGTT.Items.Add(new ListItem("Kiểm sát viên", ENUM_CHUCDANH.CHUCDANH_KSV));

            decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
            DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU]);
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(DonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlCanboHDXX.Items.Clear();
            ddlCanboHDXX.DataSource = oCBDT;
            ddlCanboHDXX.DataTextField = "HOTEN";
            ddlCanboHDXX.DataValueField = "ID";
            ddlCanboHDXX.DataBind();
            ddlCanboHDXX.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlNguoiphancong.Items.Clear();
            ddlNguoiphancong.DataSource = oCBDT;
            ddlNguoiphancong.DataTextField = "MA_TEN";
            ddlNguoiphancong.DataValueField = "ID";
            ddlNguoiphancong.DataBind();
            lbCanboHDXX.Text = "Tên thẩm phán";

            Cls_Comon.SetFocus(this, this.GetType(), ddlCanboHDXX.ClientID);

        }
        protected void loadDDLThuly()
        {
            DataTable tbl = null;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            //Lấy danh sách Chánh án, phó chánh án, Chánh VP, Phó chánh VP, Thẩm phán
            tbl = cb_BL.DM_CANBO_GETBYDONVI_THULY(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

            if (tbl != null)
            {
                foreach (DataRow T in tbl.Rows)
                {
                    if (",48836,1417,507,383,486,487,474,473,384,490,491,492,".Contains("," + T["CHUCDANHID"].ToString() + ","))
                    {
                        ddlCanboThuly.Items.Clear();
                        ddlCanboThuly.DataSource = tbl;
                        ddlCanboThuly.DataTextField = "MA_TEN";
                        ddlCanboThuly.DataValueField = "ID";
                        ddlCanboThuly.DataBind();
                    }
                }
            }
        }
        protected void loadInfo(decimal DONID)
        {
            try
            {
                decimal SOTHAM_KHANGCAO_ID = Convert.ToDecimal(hddKhangcaoID.Value);
                AHN_DON don = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault<AHN_DON>();
                AHN_SOTHAM_KHANGCAO khangcao = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == SOTHAM_KHANGCAO_ID).FirstOrDefault<AHN_SOTHAM_KHANGCAO>();
                AHN_DON_DUONGSU duongsu = dt.AHN_DON_DUONGSU.Where(x => x.ID == khangcao.DUONGSUID && x.DONID == don.ID).FirstOrDefault<AHN_DON_DUONGSU>();
                DM_DATAITEM tucachtotung;
                if (duongsu == null)
                {
                    AHN_DON_THAMGIATOTUNG tgtt = dt.AHN_DON_THAMGIATOTUNG.Where(x => x.ID == khangcao.DUONGSUID && x.DONID == don.ID).FirstOrDefault<AHN_DON_THAMGIATOTUNG>();
                    tucachtotung = dt.DM_DATAITEM.Where(x => x.MA == tgtt.TUCACHTGTTID).FirstOrDefault<DM_DATAITEM>();
                    lblNguoiKhangcao.InnerText = tgtt.HOTEN + " - " + tucachtotung.TEN;
                }
                else
                {
                    tucachtotung = dt.DM_DATAITEM.Where(x => x.MA == duongsu.TUCACHTOTUNG_MA).FirstOrDefault<DM_DATAITEM>();
                    lblNguoiKhangcao.InnerText = duongsu.TENDUONGSU + " - " + tucachtotung.TEN;
                }

                DM_TOAAN toaxxsotham = dt.DM_TOAAN.Where(x => x.ID == don.TOAANID).FirstOrDefault<DM_TOAAN>();

                lblToaXetxuSotham.InnerText = toaxxsotham.TEN;
                if (khangcao.LOAIKHANGCAO == 0) // bản án
                {
                    AHN_SOTHAM_BANAN banansotham = dt.AHN_SOTHAM_BANAN.Where(x => x.ID == khangcao.SOQDBA).FirstOrDefault<AHN_SOTHAM_BANAN>();
                    lblBaqd.InnerText = "Số " + banansotham.SOBANAN + " ngày " + (string.IsNullOrEmpty(banansotham.NGAYTUYENAN + "") ? "" : ((DateTime)banansotham.NGAYTUYENAN).ToString("dd/MM/yyyy", cul));
                }
                else if (khangcao.LOAIKHANGCAO == 1) // quyết định
                {
                    AHN_SOTHAM_QUYETDINH quyetdinhsotham = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == khangcao.SOQDBA).FirstOrDefault<AHN_SOTHAM_QUYETDINH>();
                    lblBaqd.InnerText = "Số " + quyetdinhsotham.SOQD + " ngày " + (string.IsNullOrEmpty(quyetdinhsotham.NGAYQD + "") ? "" : ((DateTime)quyetdinhsotham.NGAYQD).ToString("dd/MM/yyyy", cul));
                }
                else if (khangcao.LOAIKHANGCAO == 2) // quyết định khác
                {
                    AHN_SOTHAM_QUYETDINH quyetdinhsotham = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == khangcao.SOQDBA).FirstOrDefault<AHN_SOTHAM_QUYETDINH>();
                    lblBaqd.InnerText = "Số " + quyetdinhsotham.SOQD + " ngày " + (string.IsNullOrEmpty(quyetdinhsotham.NGAYQD + "") ? "" : ((DateTime)quyetdinhsotham.NGAYQD).ToString("dd/MM/yyyy", cul));
                }
                lblTenVuAn.InnerText = don.TENVUVIEC;
                lblNgayKhangcao.InnerText = string.IsNullOrEmpty(khangcao.NGAYKHANGCAO + "") ? "" : ((DateTime)khangcao.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                lblNoidungKhangcao.InnerText = khangcao.NOIDUNGKHANGCAO;
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }


        protected void loadThuly(decimal DONID)
        {
            try
            {

                STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();
                DataTable oDT = oBL.KHANGCAOQUAHAN_THULY_GETLAST(DONID, LOAIAN, Convert.ToDecimal(hddKhangcaoID.Value + ""));

                if (oDT.Rows.Count > 0)
                {
                    KHANGCAOQUAHAN_THULY oND = DataExtensions.FindById<KHANGCAOQUAHAN_THULY>(Convert.ToInt32(oDT.Rows[0]["ID"] + ""));

                    if (oND != null)
                    {
                        hddThulyid.Value = oND.ID.ToString();
                        if (oND.NGAYTHULY != null)
                            txtNgaythuly.Text = ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul);

                        txtSothuly.Text = oND.SOTHULY;

                        ddlCanboThuly.SelectedValue = oND.NGUOITHULYID + "";
                        txtNgaytaoThuly.Text = oDT.Rows[0]["NGAYSUACUOI"] + "";
                    }
                }
                else
                {
                    lbthongBaoUpdateThuly.Text = "Bạn chưa nhập thụ lý!";
                }
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateThuly.Text = ex.Message;
            }
        }
        protected void cmdSuggestSoThuly_Click(object sender, EventArgs e)
        {
            try
            {
                decimal SOTHAM_KHANGCAO_ID = Convert.ToDecimal(hddKhangcaoID.Value);
                if (SOTHAM_KHANGCAO_ID != 0)
                {
                    AHN_SOTHAM_KHANGCAO oKhangcao = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == SOTHAM_KHANGCAO_ID).FirstOrDefault<AHN_SOTHAM_KHANGCAO>();

                    STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();

                    if (Cls_Comon.IsValidDate(txtNgaythuly.Text) == false)
                    {
                        lbthongBaoUpdateThuly.Text = "Bạn phải nhập ngày thụ lý theo theo định dạng (dd/MM/yyyy)!";
                        txtNgaythuly.Focus();
                        return;
                    }

                    decimal VTOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    string VNGAYTHULY = txtNgaythuly.Text;
                    decimal VLOAIKHANGCAO = Convert.ToDecimal(oKhangcao.LOAIKHANGCAO);

                    txtSothuly.Text = oBL.SOTHULY_GETMAXTT(VTOAANID, VLOAIKHANGCAO, VNGAYTHULY).ToString();

                }

            }
            catch (Exception ex)
            {
                lbthongBaoUpdateThuly.Text = ex.Message;
            }
        }
        protected void cmdCapnhatThuly_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddVuViecID.Value);

                if (dgList_HDXX.Items.Count > 0)
                {
                    lbthongBaoUpdateThuly.Text = "Đã có hội đồng xét xử! Không được sửa!";
                    return;
                }

                if (hddKetqua.Value != "" && hddKetqua.Value != "0")
                {
                    lbthongBaoUpdateThuly.Text = "Đã có kết quả kháng cáo quá han! Không được sửa!";
                    return;
                }

                if (Cls_Comon.IsValidDate(txtNgaythuly.Text) == false)
                {
                    lbthongBaoUpdateThuly.Text = "Bạn phải nhập ngày thụ lý theo theo định dạng (dd/MM/yyyy)!";
                    txtNgaythuly.Focus();
                    return;
                }
                if (txtSothuly.Text.Length == 0)
                {
                    lbthongBaoUpdateThuly.Text = "Bạn chưa nhập số thụ lý. Hãy chọn lại!";
                    txtSothuly.Focus();
                    return;
                }
                //if (ddlCanboThuly.SelectedValue == "0")
                //{
                //    lbthongBaoUpdateThuly.Text = "Bạn chưa chọn cán bộ thụ lý. Hãy chọn lại!";
                //    ddlCanboThuly.Focus();
                //    return;
                //}

                KHANGCAOQUAHAN_THULY oThuly;
                if (hddThulyid.Value == "" || hddThulyid.Value == "0")
                {
                    oThuly = new KHANGCAOQUAHAN_THULY();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddThulyid.Value);
                    oThuly = DataExtensions.FindById<KHANGCAOQUAHAN_THULY>(ID);
                }

                oThuly.DONID = DONID;
                oThuly.KHANGCAOID = Convert.ToDecimal(hddKhangcaoID.Value + "");
                oThuly.LOAIAN = LOAIAN;
                oThuly.SOTHULY = txtSothuly.Text;
                oThuly.NGAYTHULY = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oThuly.NGUOITHULYID = (String.IsNullOrEmpty(ddlCanboThuly.SelectedValue)) ? 0 : Convert.ToDecimal(ddlCanboThuly.SelectedValue);

                AHN_SOTHAM_KHANGCAO oKhangcao = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == oThuly.KHANGCAOID).FirstOrDefault<AHN_SOTHAM_KHANGCAO>();
                oThuly.LOAIKHANGCAO = oKhangcao.LOAIKHANGCAO;

                Decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();
                decimal SOTHAM_KHANGCAO_ID = Convert.ToDecimal(hddKhangcaoID.Value);
                if (oBL.SOTHULY_GETMAXTT_CHECK(CurrDonViID, (decimal)oKhangcao.LOAIKHANGCAO, txtSothuly.Text, txtNgaythuly.Text))
                {
                    lbthongBaoUpdateThuly.Text = "Số thụ lý " + txtSothuly.Text + " đã có trong hệ thống!";
                    txtSothuly.Focus();
                    return;
                }

                if (hddThulyid.Value == "" || hddThulyid.Value == "0")
                {
                    oThuly.NGAYTAO = DateTime.Now;
                    oThuly.NGUOITAO = CurrUserName + "";
                    if (CurrDonViID > 0)
                        oThuly.TOAANID = CurrDonViID;
                    DataExtensions.Insert(oThuly);
                }
                else
                {
                    oThuly.NGAYSUA = DateTime.Now;
                    oThuly.NGUOISUA = CurrUserName + "";
                }

                hddThulyid.Value = oThuly.ID.ToString();

                DataExtensions.Update(oThuly);
                lbthongBaoUpdateThuly.Text = "Lưu thành công!";
                loadThuly(DONID);
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateThuly.Text = ex.Message;
            }
        }
        protected void cmdXoaThuly_Click(object sender, EventArgs e)
        {
            if (dgList_HDXX.Items.Count == 0 && (hddKetqua.Value == "" || hddKetqua.Value == "0"))
            {
                KHANGCAOQUAHAN_THULY oND = DataExtensions.FindById<KHANGCAOQUAHAN_THULY>(Convert.ToDecimal(hddThulyid.Value));
                if (oND != null)
                {
                    DataExtensions.Delete(oND);
                    resetThuly();
                    lbthongBaoUpdateThuly.Text = "Xóa thành công!";
                }
            }
            else
            {
                lbthongBaoUpdateThuly.Text = "Đã có Hội đồng xét xử hoặc Kết quả kháng cáo quá hạn, không được xóa!";
                return;
            }
        }
        protected void resetThuly()
        {
            hddThulyid.Value = "0";

            txtNgaythuly.Text = "";
            txtSothuly.Text = "";
            ddlCanboThuly.SelectedIndex = 0;
            txtNgaytaoThuly.Text = "";
        }


        private void LoadGrid_HDXX()
        {
            STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();

            decimal DONID = Convert.ToDecimal(hddVuViecID.Value + "");
            decimal THULYID = Convert.ToDecimal(hddThulyid.Value + "");

            DataTable oDT = oBL.KHANGCAOQUAHAN_HDXX_GETLIST(DONID, THULYID, LOAIAN);

            //if (oDT != null && oDT.Rows.Count > 0)
            //{
            dgList_HDXX.DataSource = oDT;
            dgList_HDXX.DataBind();
            //}
        }
        protected void dgList_HDXX_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Sua":
                        lbthongBaoUpdateHDXX.Text = "";
                        hddHdxxid.Value = e.CommandArgument.ToString();
                        cmdSua_HDXX_Click(ND_id);
                        break;
                    case "Xoa":
                        cmdXoaHDXX_Click(ND_id);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_HDXX_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                decimal DONID = Convert.ToDecimal(hddVuViecID.Value + "");

            }
        }


        protected void cmdCapnhaHDXX_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddVuViecID.Value);
                decimal THULYID = Convert.ToDecimal(hddThulyid.Value);

                if (THULYID == 0)
                {
                    lbthongBaoUpdateHDXX.Text = "Bạn chưa nhập thụ lý!!";
                    return;
                }

                if (hddKetqua.Value != "" && hddKetqua.Value != "0")
                {
                    lbthongBaoUpdateThuly.Text = "Đã có kết quả kháng cáo quá han! Không được sửa!";
                    return;
                }

                if (ddlCanboHDXX.SelectedValue == "0")
                {
                    lbthongBaoUpdateHDXX.Text = "Bạn chưa chọn thẩm phán. Hãy chọn lại!";
                    ddlCanboHDXX.Focus();
                    return;
                }

                if (txtNgayphancong.Text.Length != 0)
                {
                    if (Cls_Comon.IsValidDate(txtNgayphancong.Text) == false)
                    {
                        lbthongBaoUpdateHDXX.Text = "Bạn phải nhập ngày được phân công theo định dạng (dd/MM/yyyy)!";
                        txtNgayphancong.Focus();
                        return;
                    }
                }

                if (txtNhanphancong.Text.Length != 0)
                {
                    if (Cls_Comon.IsValidDate(txtNhanphancong.Text) == false)
                    {
                        lbthongBaoUpdateHDXX.Text = "Bạn phải nhập ngày nhận phân công theo định dạng (dd/MM/yyyy)!";
                        txtNhanphancong.Focus();
                        return;
                    }
                }

                KHANGCAOQUAHAN_HDXX oHDXX;
                if (hddHdxxid.Value == "" || hddHdxxid.Value == "0")
                {
                    oHDXX = new KHANGCAOQUAHAN_HDXX();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddHdxxid.Value);
                    oHDXX = DataExtensions.FindById<KHANGCAOQUAHAN_HDXX>(ID);
                }

                oHDXX.DONID = DONID;
                oHDXX.LOAIAN = LOAIAN;
                oHDXX.THULYID = THULYID;

                oHDXX.MAVAITRO = ddlTucachTGTT.SelectedValue;
                oHDXX.CANBOID = Convert.ToDecimal(ddlCanboHDXX.SelectedValue);

                oHDXX.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
                oHDXX.NGAYPHANCONG = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oHDXX.NGAYNHANPHANCONG = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oHDXX.HIEULUC = 1;

                Decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                if (hddHdxxid.Value == "" || hddHdxxid.Value == "0")
                {
                    oHDXX.NGAYTAO = DateTime.Now;
                    oHDXX.NGUOITAO = CurrUserName + "";
                    if (CurrDonViID > 0)
                        oHDXX.TOAANID = CurrDonViID;
                    DataExtensions.Insert(oHDXX);
                }
                else
                {
                    oHDXX.NGAYSUA = DateTime.Now;
                    oHDXX.NGUOISUA = CurrUserName + "";
                }

                DataExtensions.Update(oHDXX);
                lbthongBaoUpdateHDXX.Text = "Lưu thành công!";
                resetHDXX();
                LoadGrid_HDXX();
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateHDXX.Text = "Không thành công!" + "\n" + ex.Message;
            }
        }
        private void cmdSua_HDXX_Click(decimal ID)
        {
            try
            {
                STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();

                decimal DONID = Convert.ToDecimal(hddVuViecID.Value + "");
                decimal THULYID = Convert.ToDecimal(hddThulyid.Value + "");

                DataTable oDT = oBL.KHANGCAOQUAHAN_HDXX_GETBYID(DONID, THULYID, LOAIAN, ID);

                ddlTucachTGTT.SelectedValue = oDT.Rows[0]["MAVAITRO"] + "";
                ddlCanboHDXX.SelectedValue = oDT.Rows[0]["CANBOID"] + "";
                ddlNguoiphancong.SelectedValue = oDT.Rows[0]["NGUOIPHANCONGID"] + "";

                if (oDT.Rows[0]["NGAYPHANCONG"] != null)
                    txtNgayphancong.Text = ((DateTime)oDT.Rows[0]["NGAYPHANCONG"]).ToString("dd/MM/yyyy", cul);

                if (oDT.Rows[0]["NGAYNHANPHANCONG"] != null)
                    txtNhanphancong.Text = ((DateTime)oDT.Rows[0]["NGAYNHANPHANCONG"]).ToString("dd/MM/yyyy", cul);
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateHDXX.Text = ex.Message;
            }

        }
        protected void cmdXoaHDXX_Click(decimal ID)
        {
            if (hddKetqua.Value == "" || hddKetqua.Value == "0")
            {
                KHANGCAOQUAHAN_HDXX oND = DataExtensions.FindById<KHANGCAOQUAHAN_HDXX>(ID);
                if (oND != null)
                {
                    DataExtensions.Delete(oND);
                    resetHDXX();
                    LoadGrid_HDXX();
                    lbthongBaoUpdateHDXX.Text = "Xóa thành công!";
                }
            }
            else
            {
                lbthongBaoUpdateHDXX.Text = "Đã có kết quả kháng cáo quá hạn, không được xóa!";
            }
        }
        protected void cmdLammoiHDXX_Click(object sender, EventArgs e)
        {
            resetHDXX();
        }
        protected void resetHDXX()
        {
            //loadDDLHDXX();
            hddHdxxid.Value = "";
            txtNgayphancong.Text = "";
            txtNhanphancong.Text = "";
            txtNgayketthuc.Text = "";
        }


        protected void loadKetqua(decimal DONID)
        {
            try
            {

                STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();
                DataTable oDT = oBL.KHANGCAOQUAHAN_QUYETDINH_GETLAST(DONID, Convert.ToDecimal(hddThulyid.Value + ""), LOAIAN);

                if (oDT.Rows.Count > 0)
                {
                    KHANGCAOQUAHAN_QUYETDINH oND = DataExtensions.FindById<KHANGCAOQUAHAN_QUYETDINH>(Convert.ToInt32(oDT.Rows[0]["ID"] + ""));

                    if (oND != null)
                    {
                        hddKetqua.Value = oND.ID.ToString();

                        if (oND.NGAYQD != null)
                            txtNgayQD.Text = ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);

                        txtSoQD.Text = oND.SOQD;
                        txtLydoKCQH.Text = oND.LYDOKCQH != null ? oND.LYDOKCQH.ToString() : "";
                        rdbChapnhan.SelectedValue = oND.KETQUA.ToString();

                        if (oND.NGAYGIAIQUYET != null)
                            txtNgaygiaiquyet.Text = ((DateTime)oND.NGAYGIAIQUYET).ToString("dd/MM/yyyy", cul);

                        txtNgaytaoKetqua.Text = oDT.Rows[0]["NGAYSUACUOI"] + "";
                        txtGQGhichu.Text = oND.GHICHU;
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateKetqua.Text = ex.Message;
            }
        }
        protected void cmdSuggestSoQD_Click(object sender, EventArgs e)
        {
            try
            {
                decimal SOTHAM_KHANGCAO_ID = Convert.ToDecimal(hddKhangcaoID.Value);
                if (SOTHAM_KHANGCAO_ID != 0)
                {
                    AHN_SOTHAM_KHANGCAO oKhangcao = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == SOTHAM_KHANGCAO_ID).FirstOrDefault<AHN_SOTHAM_KHANGCAO>();

                    STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();

                    if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                    {
                        lbthongBaoUpdateKetqua.Text = "Bạn phải nhập ngày thụ lý theo theo định dạng (dd/MM/yyyy)!";
                        txtNgayQD.Focus();
                        return;
                    }

                    decimal VTOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    string VNGAYQUYETDINH = txtNgayQD.Text;

                    txtSoQD.Text = oBL.SOQUYETDINH_GETMAXTT(VTOAANID, VNGAYQUYETDINH).ToString();

                }

            }
            catch (Exception ex)
            {
                lbthongBaoUpdateKetqua.Text = ex.Message;
            }
        }
        protected void cmdCapnhatKetqua_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddVuViecID.Value);
                decimal THULYID = Convert.ToDecimal(hddThulyid.Value);

                if (dgList_HDXX.Items.Count == 0)
                {
                    lbthongBaoUpdateKetqua.Text = "Bạn chưa nhập hội đồng xet xử!";
                    return;
                }

                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbthongBaoUpdateKetqua.Text = "Bạn phải nhập ngày quyết định theo theo định dạng (dd/MM/yyyy)!";
                    txtNgayQD.Focus();
                    return;
                }

                if (txtSoQD.Text.Length == 0)
                {
                    lbthongBaoUpdateKetqua.Text = "Bạn chưa nhập số quyết định. Hãy chọn lại!";
                    txtSoQD.Focus();
                    return;
                }
                if (Cls_Comon.IsValidDate(txtNgaygiaiquyet.Text) == false)
                {
                    lbthongBaoUpdateKetqua.Text = "Bạn phải nhập ngày giải quyết theo theo định dạng (dd/MM/yyyy)!";
                    txtNgaygiaiquyet.Focus();
                    return;
                }

                KHANGCAOQUAHAN_QUYETDINH oKetqua;
                if (hddKetqua.Value == "" || hddKetqua.Value == "0")
                {
                    oKetqua = new KHANGCAOQUAHAN_QUYETDINH();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddKetqua.Value);
                    oKetqua = DataExtensions.FindById<KHANGCAOQUAHAN_QUYETDINH>(ID);
                }

                oKetqua.DONID = DONID;
                oKetqua.LOAIAN = LOAIAN;
                oKetqua.THULYID = THULYID;

                oKetqua.SOQD = txtSoQD.Text;
                oKetqua.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oKetqua.LYDOKCQH = txtLydoKCQH.Text;
                oKetqua.KETQUA = Convert.ToDecimal(rdbChapnhan.SelectedValue);
                oKetqua.NGAYGIAIQUYET = (String.IsNullOrEmpty(txtNgaygiaiquyet.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaygiaiquyet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oKetqua.GHICHU = txtGQGhichu.Text;

                Decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();
                decimal SOTHAM_KHANGCAO_ID = Convert.ToDecimal(hddKhangcaoID.Value);
                if (oBL.SOQUYETDINH_GETMAXTT_CHECK(CurrDonViID, txtSoQD.Text, txtNgayQD.Text) && oKetqua.SOQD != txtSoQD.Text)
                {
                    lbthongBaoUpdateKetqua.Text = "Số quyết định " + txtSoQD.Text + " đã có trong hệ thống!";
                    txtSoQD.Focus();
                    return;
                }

                if (hddKetqua.Value == "" || hddKetqua.Value == "0")
                {
                    oKetqua.NGAYTAO = DateTime.Now;
                    oKetqua.NGUOITAO = CurrUserName + "";
                    if (CurrDonViID > 0)
                        oKetqua.TOAANID = CurrDonViID;
                    DataExtensions.Insert(oKetqua);
                }
                else
                {
                    oKetqua.NGAYSUA = DateTime.Now;
                    oKetqua.NGUOISUA = CurrUserName + "";
                }

                hddKetqua.Value = oKetqua.ID.ToString();

                DataExtensions.Update(oKetqua);
                lbthongBaoUpdateKetqua.Text = "Lưu thành công!";
                loadKetqua(DONID);
                cmdCapnhatKetqua_old();
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateKetqua.Text = ex.Message;
            }

        }
        protected void cmdXoaKetqua_Click(object sender, EventArgs e)
        {
            KHANGCAOQUAHAN_QUYETDINH oND = DataExtensions.FindById<KHANGCAOQUAHAN_QUYETDINH>(Convert.ToDecimal(hddKetqua.Value));
            if (oND != null)
            {
                DataExtensions.Delete(oND);
                resetkKetqua();
                hddKetqua.Value = "0";
                lbthongBaoUpdateKetqua.Text = "Xóa thành công!";
            }
            cmdXoaKetqua_old();
        }
        protected void resetkKetqua()
        {
            txtLydoKCQH.Text = "";
            txtNgayQD.Text = "";
            txtSoQD.Text = "";
            txtNgaygiaiquyet.Text = "";
            txtNgaytaoKetqua.Text = "";
            txtGQGhichu.Text = "";
        }

        protected void cmdCapnhatKetqua_old()
        {
            decimal VuViecID = Convert.ToDecimal(hddVuViecID.Value),
                    DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            AHN_SOTHAM_KHANGCAO oT = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == VuViecID && x.GQ_TOAANID == DonViID).FirstOrDefault();
            if (oT != null)
            {
                //Cập nhật lại thông tin giải quyết kháng cáo quá hạn
                oT.GQ_NGAY = txtNgaygiaiquyet.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaygiaiquyet.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                //Lấy riêng chủ tọa
                KHANGCAOQUAHAN_HDXX Chutoa = DataExtensions.GetAllWithClause<KHANGCAOQUAHAN_HDXX>("THULYID = " + hddThulyid.Value + "AND MAVAITRO LIKE 'THAMPHAN' ORDER BY NGAYNHANPHANCONG").FirstOrDefault();
                oT.GQ_THAMPHANID = Convert.ToDecimal(Chutoa.CANBOID);

                KHANGCAOQUAHAN_HDXX thamphan_1 = DataExtensions.GetAllWithClause<KHANGCAOQUAHAN_HDXX>("THULYID = " + hddThulyid.Value + "AND MAVAITRO LIKE 'THAMPHANHDXX' ORDER BY NGAYNHANPHANCONG").FirstOrDefault();
                if (thamphan_1 != null)
                {
                    oT.GQ_THAMPHANID_1 = Convert.ToDecimal(thamphan_1.CANBOID);
                    KHANGCAOQUAHAN_HDXX thamphan_2 = DataExtensions.GetAllWithClause<KHANGCAOQUAHAN_HDXX>("THULYID = " + hddThulyid.Value + "AND MAVAITRO LIKE 'THAMPHANHDXX' AND CANBOID != " + thamphan_1.CANBOID + " ORDER BY NGAYNHANPHANCONG").FirstOrDefault();
                    if (thamphan_2 != null)
                    {
                        oT.GQ_THAMPHANID_2 = Convert.ToDecimal(thamphan_1.CANBOID);
                    }
                    else
                    {
                        lbthongbao.Text = "Chưa nhập thẩm phán hội đồng xét xử!";
                    }
                }
                else
                {
                    lbthongbao.Text = "Chưa nhập thẩm phán hội đồng xét xử!";
                }



                oT.GQ_ISCHAPNHAN = Convert.ToDecimal(rdbChapnhan.SelectedValue);
                oT.GQ_TINHTRANG = 1;
                oT.GQ_GHICHU = txtGQGhichu.Text;

                //Decimal FileID = oT.FILEID + "" == "" ? 0 : (decimal)oT.FILEID;

                dt.SaveChanges();
            }
            else
            {
                lbthongbao.Text = "Không tìm thấy kháng cáo cần giải quyết!";
            }

        }
        protected void cmdXoaKetqua_old()
        {
            decimal KHANGCAOID = Convert.ToDecimal(hddKhangcaoID.Value);
            AHN_SOTHAM_KHANGCAO oND = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == KHANGCAOID).FirstOrDefault();
            if (oND != null)
            {
                oND.GQ_NGAY = null;
                oND.GQ_THAMPHANID = null;
                oND.GQ_THAMPHANID_1 = null;
                oND.GQ_THAMPHANID_2 = null;
                oND.GQ_ISCHAPNHAN = null;
                oND.GQ_TINHTRANG = 0;
                oND.GQ_GHICHU = null;

                dt.SaveChanges();
            }
            lbthongbao.Text = "Hủy kết quả thành công!";
        }


        protected void btnClose_Click(object sender, EventArgs e)
        {
            resetThuly();
            resetHDXX();
            resetkKetqua();

            lbthongBaoUpdateThuly.Text = "";
            lbthongBaoUpdateHDXX.Text = "";
            lbthongBaoUpdateKetqua.Text = "";

            LoadGrid();
        }

        string TemplateWordSTPT = ConfigurationManager.AppSettings["TemplateWordSTPT"];
        protected void cmdInDanhsach_Click(DataTable tbl)
        {
            //Đường dẫn lưu file khi đã insert dữ liệu và tên file sẽ lưu trên máy người dùng
            string saveAs = TemplateWordSTPT + "rptDS_KCQH.xlsx";
            string fileNameSave = "rptDS_KCQH.xlsx";

            //Đường dẫn vào thư mục file Template.
            string dataDir = TemplateWordSTPT + "rptDanhsachinKhangcaoquahan.xlsx";

            //Open Template
            FileStream fstream = new FileStream(dataDir, FileMode.Open);
            Workbook workbook = new Workbook(fstream);
            Worksheet worksheet = workbook.Worksheets["rptDS_KCQH"];

            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN tentoaan = dt.DM_TOAAN.Where(x => x.ID == vDonViID).FirstOrDefault();
            worksheet.Cells["A1"].Value = tentoaan.TEN.ToString().ToUpper(); //Tòa án nhân dân ...
            worksheet.AutoFitRows();

            try
            {
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    //Insert công thức tính tổng các dòng vào cột C
                    decimal rowcount = 7; //Dòng đầu tiên

                    foreach (DataRow row in tbl.Rows)
                    {
                        if (Convert.ToDecimal(row["STT"] + " ") != 0 || (row["STT"] + "") != "") worksheet.Cells['A' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["STT"] + "");
                        if ((row["SOTHULY"] + "") != "") worksheet.Cells['B' + Convert.ToString(rowcount)].Value = row["SOTHULY"] + "\n\t" + row["NGAYTHULY"];
                        if ((row["LOAIAN"] + "") != "") worksheet.Cells['C' + Convert.ToString(rowcount)].Value = row["LOAIAN"] + "";
                        if ((row["TENTOAAN"] + "") != "") worksheet.Cells['D' + Convert.ToString(rowcount)].Value = (row["TENTOAAN"] + "").Replace("Tòa án nhân dân ", "");
                        if ((row["SOBAQD"] + "") != "") worksheet.Cells['E' + Convert.ToString(rowcount)].Value = row["SOBAQD"] + "\n\t" + row["NGAYBAQD"];
                        if ((row["TENVUVIEC"] + "") != "") worksheet.Cells['F' + Convert.ToString(rowcount)].Value = row["TENVUVIEC"] + "";
                        if ((row["NGUOIKHANGCAO"] + "") != "") worksheet.Cells['G' + Convert.ToString(rowcount)].Value = row["NGUOIKHANGCAO"] + "";
                        if ((row["NGAYKHANGCAO"] + "") != "") worksheet.Cells['H' + Convert.ToString(rowcount)].Value = row["NGAYKHANGCAO"] + "";
                        if ((row["KETQUA"] + "") != "") worksheet.Cells['I' + Convert.ToString(rowcount)].Value = row["KETQUA"] + "";

                        rowcount++;
                    }

                    // Accessing the "A1" cell from the worksheet
                    Cell cell = worksheet.Cells["A" + (rowcount)];

                    // Setting the horizontal alignment of the text in the "A1" cell
                    Aspose.Cells.Style style = new Aspose.Cells.Style();
                    style.HorizontalAlignment = TextAlignmentType.Center;
                    style.VerticalAlignment = TextAlignmentType.Center;
                    style.Font.Name = "Times New Roman";
                    style.Font.Size = 13;
                    style.Font.IsBold = true;

                    cell.SetStyle(style);

                    // Create a range (A5:0[rowcount]).
                    Cells cells = worksheet.Cells;
                    Aspose.Cells.Range range = cells.CreateRange("A7", "I" + (rowcount - 1));

                    //set inner boder of range
                    Aspose.Cells.Style stl = workbook.Styles[workbook.Styles.Add()];
                    stl.Borders[Aspose.Cells.BorderType.TopBorder].LineStyle = CellBorderType.Thin;
                    stl.Borders[Aspose.Cells.BorderType.TopBorder].Color = System.Drawing.Color.Black;
                    stl.Borders[Aspose.Cells.BorderType.LeftBorder].LineStyle = CellBorderType.Thin;
                    stl.Borders[Aspose.Cells.BorderType.LeftBorder].Color = System.Drawing.Color.Black;
                    stl.Borders[Aspose.Cells.BorderType.BottomBorder].LineStyle = CellBorderType.Thin;
                    stl.Borders[Aspose.Cells.BorderType.BottomBorder].Color = System.Drawing.Color.Black;
                    stl.Borders[Aspose.Cells.BorderType.RightBorder].LineStyle = CellBorderType.Thin;
                    stl.Borders[Aspose.Cells.BorderType.RightBorder].Color = System.Drawing.Color.Black;
                    StyleFlag flg = new StyleFlag();
                    flg.Borders = true;

                    range.ApplyStyle(stl, flg);

                    //Save the target book file.
                    workbook.Save(saveAs);

                    ExportData(fileNameSave, (string)saveAs);

                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
                fstream.Close();
            }
            //Đóng file Template và clear dữ liệu bộ nhớ
            fstream.Close();

        }

        protected void ExportData(string fileName, string path)
        {
            try
            {
                //copy to MemoryStream
                MemoryStream ms = new MemoryStream();
                using (FileStream fs = File.OpenRead(Path.Combine(path)))
                {
                    fs.CopyTo(ms);
                }

                //Delete file
                if (File.Exists(Path.Combine(path)))
                    File.Delete(Path.Combine(path));

                //Download file
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
                Response.BinaryWrite(ms.ToArray());
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
                return;
            }

            Response.End();
        }

        protected void cmdInDanhsach_Click(object sender, EventArgs e)
        {
            string CHECKEDLIST = "";


            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    CHECKEDLIST = CHECKEDLIST + chkChon.ToolTip + ";";
                }
            }

            STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();
            DataTable tbl = new DataTable();
            tbl = oBL.AHN_PT_KCQUAHAN(LOAIAN, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), txtMaVuViec.Text, txtTenVuViec.Text, txtTimkiem_SoBAQD.Text, txtTimkiem_NgayBAQD.Text, txtTimkiem_NguoiKC.Text, txtTuNgay.Text, txtDenNgay.Text,
                                                txtTimkiem_SoTL.Text, txtTimkiem_TuNgayTL.Text, txtTimkiem_DenNgayTL.Text, Convert.ToDecimal(ddlTimkiem_Trangthai.SelectedValue + ""), txtTrangthai_tungay.Text, txtTrangthai_denngay.Text, Convert.ToDecimal(ddlTimkiem_Thamphan.SelectedValue + ""), Convert.ToDecimal(ddlTimkiem_Thuky.SelectedValue + ""),
                                                CHECKEDLIST, 0, 0);
            cmdInDanhsach_Click(tbl);
        }

        protected void cmdInQuyetDinh_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddKetqua.Value == "" || hddKetqua.Value == "0")
                {
                    lbthongBaoUpdateKetqua.Text = "Bạn chưa nhập kết quả kháng cáo quá hạn!";
                    return;
                }

                KHANGCAOQUAHAN_QUYETDINH oND = DataExtensions.FindById<KHANGCAOQUAHAN_QUYETDINH>(Convert.ToInt32(hddKetqua.Value + ""));

                if (oND.KETQUA == 0) // Không chấp nhận
                {
                    cmdInQuyetDinh_KhongChapnhan();
                }
                else if (oND.KETQUA == 1) // Chấp nhận
                {
                    cmdInQuyetDinh_Chapnhan();
                }
                else // Đình chỉ
                {
                    cmdInQuyetDinh_Dinhchi();
                }

            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
                return;
            }
        }
        protected void cmdInQuyetDinh_Chapnhan()
        {
            try
            {
                if (hddKetqua.Value == "" || hddKetqua.Value == "0")
                {
                    lbthongBaoUpdateKetqua.Text = "Bạn chưa nhập kết quả kháng cáo quá hạn!";
                    return;
                }

                KHANGCAOQUAHAN_QUYETDINH oND = DataExtensions.FindById<KHANGCAOQUAHAN_QUYETDINH>(Convert.ToInt32(hddKetqua.Value + ""));

                Decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();
                DataTable tbl = oBL.AHN_PT_KCQUAHAN_PRINT(Convert.ToDecimal(hddThulyid.Value), LOAIAN, Convert.ToDecimal(hddVuViecID.Value), CurrDonViID, Convert.ToDecimal(hddKhangcaoID.Value));

                string fileName, saveAs, fileNameSave = "";

                fileName = TemplateWordSTPT + "rpt59DS.doc";
                saveAs = TemplateWordSTPT + "rpt59DS" + Session[ENUM_SESSION.SESSION_USERID] + ".doc";

                fileNameSave = "rptQD_CN_KCQH_" + tbl.Rows[0]["ITEM_HOTENNGUOIKC"].ToString().Replace(" ", "_") + ".doc"; //strNguoiNhan + 

                Document doc = new Document();
                Document baoCao = new Document(fileName);

                string strTENTOAAN = Session[ENUM_SESSION.SESSION_TENDONVI] + "";

                string strDIADIEM = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDIADIEM = "Hà Nội";
                else strDIADIEM = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                baoCao.MailMerge.Execute(new[] { "TENTOAAN" }, new[] { tbl.Rows[0]["ITEM_TENTOAAN"] });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA1" }, new[] { "TÒA ÁN NHÂN DÂN" + "\n" + tbl.Rows[0]["ITEM_TENTOAANHOA"].ToString().Substring(15) });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA2" }, new[] { tbl.Rows[0]["ITEM_TENTOAANHOA"] });
                baoCao.MailMerge.Execute(new[] { "SOQD" }, new[] { tbl.Rows[0]["ITEM_SOQD"] });
                baoCao.MailMerge.Execute(new[] { "LOAIAN" }, new[] { tbl.Rows[0]["ITEM_LOAIAN"] });
                baoCao.MailMerge.Execute(new[] { "QHPLTEXT" }, new[] { tbl.Rows[0]["ITEM_QHPLTEXT"] });

                baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { strDIADIEM });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { DateTime.Now.Day.ToString() });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { DateTime.Now.Month.ToString() });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { DateTime.Now.Year.ToString() });

                baoCao.MailMerge.Execute(new[] { "NGAYKC" }, new[] { tbl.Rows[0]["ITEM_NGAYKC"] });

                baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { Cls_Comon.FormatTenRieng(tbl.Rows[0]["ITEM_NGUOIKY"].ToString()) });
                baoCao.MailMerge.Execute(new[] { "HOTENTPCHUTOA" }, new[] { tbl.Rows[0]["ITEM_HOTENTPCHUTOA"] });
                baoCao.MailMerge.Execute(new[] { "HOTENTP1" }, new[] { tbl.Rows[0]["ITEM_HOTENTP1"] });
                baoCao.MailMerge.Execute(new[] { "HOTENTP2" }, new[] { tbl.Rows[0]["ITEM_HOTENTP2"] });

                if (tbl.Rows[0]["ITEM_TENVKSND"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "TENVKSND" }, new[] { tbl.Rows[0]["ITEM_TENVKSND"] });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "TENVKSND" }, new[] { "\t" });
                }
                if (tbl.Rows[0]["ITEM_HOTENKSV"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "HOTENKSV" }, new[] { tbl.Rows[0]["ITEM_HOTENKSV"] });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "HOTENKSV" }, new[] { "\t" });
                }

                baoCao.MailMerge.Execute(new[] { "TCTTNGUOIKC" }, new[] { tbl.Rows[0]["ITEM_TCTTNGUOIKC"] });
                baoCao.MailMerge.Execute(new[] { "HOTENNGUOIKC" }, new[] { tbl.Rows[0]["ITEM_HOTENNGUOIKC"] });
                if (tbl.Rows[0]["ITEM_YEUCAUKHANGCAO"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "YEUCAUKHANGCAO" }, new[] { tbl.Rows[0]["ITEM_YEUCAUKHANGCAO"] });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "YEUCAUKHANGCAO" }, new[] { "\t" });
                }
                if (tbl.Rows[0]["ITEM_LYDOKCQH"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "LYDOKCQH" }, new[] { tbl.Rows[0]["ITEM_LYDOKCQH"] });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "LYDOKCQH" }, new[] { "\t" });
                }

                baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { tbl.Rows[0]["ITEM_LOAIBAQD"] });
                baoCao.MailMerge.Execute(new[] { "NGAYBAQDST" }, new[] { tbl.Rows[0]["ITEM_NGAYBAQDST"] });
                baoCao.MailMerge.Execute(new[] { "SOBAQD" }, new[] { tbl.Rows[0]["ITEM_SOBAQD"] });
                baoCao.MailMerge.Execute(new[] { "TENTOAANST" }, new[] { tbl.Rows[0]["ITEM_TENTOAANST"] });
                baoCao.MailMerge.Execute(new[] { "THONGTINVUVIEC" }, new[] { tbl.Rows[0]["ITEM_THONGTINVUVIEC"] });

                doc.AppendDocument(baoCao, ImportFormatMode.KeepSourceFormatting);

                doc.Sections[0].Range.Delete();
                doc.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
                return;
            }
        }
        protected void cmdInQuyetDinh_KhongChapnhan()
        {
            try
            {
                if (hddKetqua.Value == "" || hddKetqua.Value == "0")
                {
                    lbthongBaoUpdateKetqua.Text = "Bạn chưa nhập kết quả kháng cáo quá hạn!";
                    return;
                }

                KHANGCAOQUAHAN_QUYETDINH oND = DataExtensions.FindById<KHANGCAOQUAHAN_QUYETDINH>(Convert.ToInt32(hddKetqua.Value + ""));

                Decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();
                DataTable tbl = oBL.AHN_PT_KCQUAHAN_PRINT(Convert.ToDecimal(hddThulyid.Value), LOAIAN, Convert.ToDecimal(hddVuViecID.Value), CurrDonViID, Convert.ToDecimal(hddKhangcaoID.Value));

                string fileName, saveAs, fileNameSave = "";

                fileName = TemplateWordSTPT + "rpt59DS.doc";
                saveAs = TemplateWordSTPT + "rpt59DS" + Session[ENUM_SESSION.SESSION_USERID] + ".doc";

                fileNameSave = "rptQD_CN_KCQH_" + tbl.Rows[0]["ITEM_HOTENNGUOIKC"].ToString().Replace(" ", "_") + ".doc"; //strNguoiNhan + 

                Document doc = new Document();
                Document baoCao = new Document(fileName);

                string strTENTOAAN = Session[ENUM_SESSION.SESSION_TENDONVI] + "";

                string strDIADIEM = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDIADIEM = "Hà Nội";
                else strDIADIEM = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                baoCao.MailMerge.Execute(new[] { "TENTOAAN" }, new[] { tbl.Rows[0]["ITEM_TENTOAAN"] });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA1" }, new[] { "TÒA ÁN NHÂN DÂN" + "\n" + tbl.Rows[0]["ITEM_TENTOAANHOA"].ToString().Substring(15) });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA2" }, new[] { tbl.Rows[0]["ITEM_TENTOAANHOA"] });
                baoCao.MailMerge.Execute(new[] { "SOQD" }, new[] { tbl.Rows[0]["ITEM_SOQD"] });
                baoCao.MailMerge.Execute(new[] { "LOAIAN" }, new[] { tbl.Rows[0]["ITEM_LOAIAN"] });
                baoCao.MailMerge.Execute(new[] { "QHPLTEXT" }, new[] { tbl.Rows[0]["ITEM_QHPLTEXT"] });

                baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { strDIADIEM });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { DateTime.Now.Day.ToString() });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { DateTime.Now.Month.ToString() });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { DateTime.Now.Year.ToString() });

                baoCao.MailMerge.Execute(new[] { "NGAYKC" }, new[] { tbl.Rows[0]["ITEM_NGAYKC"] });

                baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { Cls_Comon.FormatTenRieng(tbl.Rows[0]["ITEM_NGUOIKY"].ToString()) });
                baoCao.MailMerge.Execute(new[] { "HOTENTPCHUTOA" }, new[] { tbl.Rows[0]["ITEM_HOTENTPCHUTOA"] });
                baoCao.MailMerge.Execute(new[] { "HOTENTP1" }, new[] { tbl.Rows[0]["ITEM_HOTENTP1"] });
                baoCao.MailMerge.Execute(new[] { "HOTENTP2" }, new[] { tbl.Rows[0]["ITEM_HOTENTP2"] });

                if (tbl.Rows[0]["ITEM_TENVKSND"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "TENVKSND" }, new[] { tbl.Rows[0]["ITEM_TENVKSND"] });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "TENVKSND" }, new[] { "\t" });
                }
                if (tbl.Rows[0]["ITEM_HOTENKSV"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "HOTENKSV" }, new[] { tbl.Rows[0]["ITEM_HOTENKSV"] });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "HOTENKSV" }, new[] { "\t" });
                }

                baoCao.MailMerge.Execute(new[] { "TCTTNGUOIKC" }, new[] { tbl.Rows[0]["ITEM_TCTTNGUOIKC"] });
                baoCao.MailMerge.Execute(new[] { "HOTENNGUOIKC" }, new[] { tbl.Rows[0]["ITEM_HOTENNGUOIKC"] });
                if (tbl.Rows[0]["ITEM_YEUCAUKHANGCAO"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "YEUCAUKHANGCAO" }, new[] { tbl.Rows[0]["ITEM_YEUCAUKHANGCAO"] });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "YEUCAUKHANGCAO" }, new[] { "\t" });
                }
                if (tbl.Rows[0]["ITEM_LYDOKCQH"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "LYDOKCQH" }, new[] { tbl.Rows[0]["ITEM_LYDOKCQH"] });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "LYDOKCQH" }, new[] { "\t" });
                }

                baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { tbl.Rows[0]["ITEM_LOAIBAQD"] });
                baoCao.MailMerge.Execute(new[] { "NGAYBAQDST" }, new[] { tbl.Rows[0]["ITEM_NGAYBAQDST"] });
                baoCao.MailMerge.Execute(new[] { "SOBAQD" }, new[] { tbl.Rows[0]["ITEM_SOBAQD"] });
                baoCao.MailMerge.Execute(new[] { "TENTOAANST" }, new[] { tbl.Rows[0]["ITEM_TENTOAANST"] });
                baoCao.MailMerge.Execute(new[] { "THONGTINVUVIEC" }, new[] { tbl.Rows[0]["ITEM_THONGTINVUVIEC"] });

                doc.AppendDocument(baoCao, ImportFormatMode.KeepSourceFormatting);

                doc.Sections[0].Range.Delete();
                doc.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
                return;
            }
        }
        protected void cmdInQuyetDinh_Dinhchi()
        {
            try
            {
                if (hddKetqua.Value == "" || hddKetqua.Value == "0")
                {
                    lbthongBaoUpdateKetqua.Text = "Bạn chưa nhập kết quả kháng cáo quá hạn!";
                    return;
                }

                KHANGCAOQUAHAN_QUYETDINH oND = DataExtensions.FindById<KHANGCAOQUAHAN_QUYETDINH>(Convert.ToInt32(hddKetqua.Value + ""));

                Decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();
                DataTable tbl = oBL.ADS_PT_KCQUAHAN_PRINT(Convert.ToDecimal(hddThulyid.Value), LOAIAN, Convert.ToDecimal(hddVuViecID.Value), CurrDonViID, Convert.ToDecimal(hddKhangcaoID.Value));

                string fileName, saveAs, fileNameSave = "";

                fileName = TemplateWordSTPT + "rpt19VDS.doc";
                saveAs = TemplateWordSTPT + "rpt19VDS" + Session[ENUM_SESSION.SESSION_USERID] + ".doc";

                fileNameSave = "rptQD_DC_KCQH_" + tbl.Rows[0]["ITEM_HOTENNGUOIKC"].ToString().Replace(" ", "_") + ".doc"; //strNguoiNhan + 

                Document doc = new Document();
                Document baoCao = new Document(fileName);

                string strTENTOAAN = Session[ENUM_SESSION.SESSION_TENDONVI] + "";

                string strDIADIEM = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDIADIEM = "Hà Nội";
                else strDIADIEM = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { Cls_Comon.FormatTenRieng(tbl.Rows[0]["ITEM_NGUOIKY"].ToString()) });
                baoCao.MailMerge.Execute(new[] { "TENTOAAN" }, new[] { tbl.Rows[0]["ITEM_TENTOAAN"] });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA1" }, new[] { "TÒA ÁN NHÂN DÂN" + "\n" + tbl.Rows[0]["ITEM_TENTOAANHOA"].ToString().Substring(15) });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA2" }, new[] { tbl.Rows[0]["ITEM_TENTOAANHOA"] });
                baoCao.MailMerge.Execute(new[] { "SOQD" }, new[] { tbl.Rows[0]["ITEM_SOQD"] });
                baoCao.MailMerge.Execute(new[] { "LOAIAN" }, new[] { tbl.Rows[0]["ITEM_LOAIAN"] });
                baoCao.MailMerge.Execute(new[] { "QHPLTEXT" }, new[] { tbl.Rows[0]["ITEM_QHPLTEXT"] });

                baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { strDIADIEM });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { DateTime.Now.Day.ToString() });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { DateTime.Now.Month.ToString() });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { DateTime.Now.Year.ToString() });

                baoCao.MailMerge.Execute(new[] { "HOTENNGUOIKC" }, new[] { tbl.Rows[0]["ITEM_HOTENNGUOIKC"] });

                baoCao.MailMerge.Execute(new[] { "SOTHULYKCQH" }, new[] { txtSothuly.Text + "/" + txtNgaythuly.Text.Substring(Math.Max(0, txtNgaythuly.Text.Length - 4)) });

                baoCao.MailMerge.Execute(new[] { "NGAYTHULYKCQH" }, new[] { txtNgaythuly.Text });

                if (tbl.Rows[0]["ITEM_HOTENNGUOIKC"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINGUOIKC" }, new[] { tbl.Rows[0]["ITEM_DIACHINGUOIKC"] + "\n" });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINGUOIKC" }, new[] { "" });
                }

                if (tbl.Rows[0]["ITEM_NGUOI_1"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_1" }, new[] { "Người đại diện hợp pháp của người yêu cầu giải quyết việc dân sự: " }); //
                    baoCao.MailMerge.Execute(new[] { "NGUOI_1" }, new[] { tbl.Rows[0]["ITEM_NGUOI_1"] + "\n" });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_1" }, new[] { "" });
                    baoCao.MailMerge.Execute(new[] { "NGUOI_1" }, new[] { "" });
                }

                if (tbl.Rows[0]["ITEM_NGUOI_2"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_2" }, new[] { "Người bảo vệ quyền và lợi ích hợp pháp của người yêu cầu giải quyết việc dân sự: " }); //
                    baoCao.MailMerge.Execute(new[] { "NGUOI_2" }, new[] { tbl.Rows[0]["ITEM_NGUOI_2"] + "\n" });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_2" }, new[] { "" });
                    baoCao.MailMerge.Execute(new[] { "NGUOI_2" }, new[] { "" });
                }

                if (tbl.Rows[0]["ITEM_NGUOI_3"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_3" }, new[] { "- Người có quyền lợi, nghĩa vụ liên quan: " }); //
                    baoCao.MailMerge.Execute(new[] { "NGUOI_3" }, new[] { tbl.Rows[0]["ITEM_NGUOI_3"] + "\n" });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_3" }, new[] { "" });
                    baoCao.MailMerge.Execute(new[] { "NGUOI_3" }, new[] { "" });
                }

                if (tbl.Rows[0]["ITEM_NGUOI_4"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_4" }, new[] { "Người đại diện hợp pháp của người có quyền lợi, nghĩa vụ liên quan: " });
                    baoCao.MailMerge.Execute(new[] { "NGUOI_4" }, new[] { tbl.Rows[0]["ITEM_NGUOI_4"] + "\n" });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_4" }, new[] { "" });
                    baoCao.MailMerge.Execute(new[] { "NGUOI_4" }, new[] { "" });
                }

                if (tbl.Rows[0]["ITEM_NGUOI_5"].ToString() != "")
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_5" }, new[] { "Người bảo vệ quyền và lợi ích hợp pháp của người có quyền lợi, nghĩa vụ liên quan: " });
                    baoCao.MailMerge.Execute(new[] { "NGUOI_5" }, new[] { tbl.Rows[0]["ITEM_NGUOI_5"] });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DONG_NGUOI_5" }, new[] { "" });
                    baoCao.MailMerge.Execute(new[] { "NGUOI_5" }, new[] { "" });
                }

                baoCao.MailMerge.Execute(new[] { "QHPLTEXT" }, new[] { tbl.Rows[0]["ITEM_QHPLTEXT"] });

                doc.AppendDocument(baoCao, ImportFormatMode.KeepSourceFormatting);

                doc.Sections[0].Range.Delete();
                doc.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
                return;
            }
        }
        private string getDiaDiem(decimal ToaAnID)
        {
            try
            {
                string strDiadiem = "";
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                strDiadiem = oT.TEN.Replace("Tòa án nhân dân ", "");
                switch (oT.LOAITOA)
                {
                    case "CAPHUYEN":
                        DM_TOAAN opT = dt.DM_TOAAN.Where(x => x.ID == oT.CAPCHAID).FirstOrDefault();
                        strDiadiem = opT.TEN.Replace("Tòa án nhân dân ", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPTINH":
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPCAO":
                        strDiadiem = strDiadiem.Replace("cấp cao", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                }
                return strDiadiem;
            }
            catch (Exception ex) { return ""; }
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            txtMaVuViec.Text = "";
            txtTenVuViec.Text = "";
            txtTimkiem_SoBAQD.Text = "";
            txtTimkiem_NgayBAQD.Text = "";
            txtTimkiem_NguoiKC.Text = "";
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
            txtTimkiem_SoTL.Text = "";
            txtTimkiem_TuNgayTL.Text = "";
            txtTimkiem_DenNgayTL.Text = "";
            ddlTimkiem_Trangthai.SelectedValue = "2";
            txtTrangthai_tungay.Text = "";
            txtTrangthai_denngay.Text = "";
            ddlTimkiem_Thamphan.SelectedValue = "0";
            ddlTimkiem_Thuky.SelectedValue = "0";
        }
    }
}