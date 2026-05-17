using BL.GSTP;
using BL.GSTP.APS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.QLAN;
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

namespace WEB.GSTP.QLAN.KHANGCAOQUAHAN
{
    public partial class Capnhatkhangcaoquahan_APS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        private decimal LOAIAN = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);
        private decimal SOTHAM_KHANGCAO_ID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddPageIndex.Value = "1";
                    LoadGrid();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
            APS_PHUCTHAM_BL oBL = new APS_PHUCTHAM_BL();
            int pageSize = dgList.PageSize, pageIndex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = oBL.APS_PT_KCQUAHAN(vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, dFrom, dTo, Convert.ToDecimal(rdbTrangthai.SelectedValue), pageIndex, pageSize);
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
                        lbthongbao.Text = "Bạn phải nhập kháng cáo từ ngày phải nhỏ hơn đến ngày!";
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

            btnClose_Click(source, e);
            decimal DONID = 0;
            string StrPara = "";
            StrPara = e.CommandArgument.ToString();
            if (StrPara.Contains(";#"))
            {
                string[] arr = StrPara.Split(';');
                DONID = Convert.ToDecimal(arr[0] + "");
                SOTHAM_KHANGCAO_ID = Convert.ToDecimal(arr[1].Replace("#", "") + "");
            }

            hddKhangcaoID.Value = SOTHAM_KHANGCAO_ID.ToString();

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
            //if (rdbTrangthai.SelectedValue == "1")
            //{
            //    //Cls_Comon.SetButton(cmdGiaiQuyet, false);
            //    return;
            //}
            //CheckBox chkXem = (CheckBox)sender;
            //decimal ID = Convert.ToDecimal(chkXem.ToolTip);
            //foreach (DataGridItem Item in dgList.Items)
            //{
            //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
            //    if (chkXem.Checked)
            //    {
            //        if (chkXem.ToolTip != chkChon.ToolTip) chkChon.Checked = false;
            //        //Cls_Comon.SetButton(cmdGiaiQuyet, true);
            //    }
            //    //else
            //        //Cls_Comon.SetButton(cmdGiaiQuyet, false);
            //}
        }
        protected void ddlTucachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string tucach = ddlTucachTGTT.SelectedValue;
            if (tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET)
            {
                lbCanboHDXX.Text = "Thư ký phiên tòa";

                ddlCanboHDXX.Items.Clear();
                tbl = objBL.DM_CANBO_GetAllThuKy_TTV(DonViID, ENUM_CHUCDANH.CHUCDANH_THUKY);
                ddlCanboHDXX.DataSource = tbl;
                ddlCanboHDXX.DataTextField = "MA_TEN";
                ddlCanboHDXX.DataValueField = "ID";
                ddlCanboHDXX.DataBind();
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanboHDXX.ClientID);
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND)
            {
                lbCanboHDXX.Text = "Tên Hội thẩm nhân dân";
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanboHDXX.ClientID);
            }
            else
            {
                loadDDLHDXX();
                lbCanboHDXX.Text = "Tên thẩm phán";
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanboHDXX.ClientID);
            }

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
        }
        protected void loadDDLThuly()
        {
            DataTable tbl = null;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            //Lấy danh sách Chánh án, phó chánh án, Chánh VP, Phó chánh VP, Thẩm phán
            tbl = cb_BL.DM_CANBO_GETBYDONVI_THULY(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanboThuly.Items.Clear();
            ddlCanboThuly.DataSource = tbl;
            ddlCanboThuly.DataTextField = "MA_TEN";
            ddlCanboThuly.DataValueField = "ID";
            ddlCanboThuly.DataBind();
        }
        protected void loadInfo(decimal DONID)
        {
            try
            {
                APS_DON don = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault<APS_DON>();
                APS_SOTHAM_KHANGCAO khangcao = dt.APS_SOTHAM_KHANGCAO.Where(x => x.ID == SOTHAM_KHANGCAO_ID).FirstOrDefault<APS_SOTHAM_KHANGCAO>();
                APS_DON_DUONGSU duongsu = dt.APS_DON_DUONGSU.Where(x => x.ID == khangcao.DUONGSUID && x.DONID == don.ID).FirstOrDefault<APS_DON_DUONGSU>();
                DM_DATAITEM tucachtotung;
                if (duongsu == null)
                {
                    APS_DON_THAMGIATOTUNG tgtt = dt.APS_DON_THAMGIATOTUNG.Where(x => x.ID == khangcao.DUONGSUID && x.DONID == don.ID).FirstOrDefault<APS_DON_THAMGIATOTUNG>();
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
                    APS_SOTHAM_BANAN banansotham = dt.APS_SOTHAM_BANAN.Where(x => x.ID == khangcao.SOQDBA).FirstOrDefault<APS_SOTHAM_BANAN>();
                    lblBaqd.InnerText = "Số " + banansotham.SOBANAN + " ngày " + (string.IsNullOrEmpty(banansotham.NGAYTUYENAN + "") ? "" : ((DateTime)banansotham.NGAYTUYENAN).ToString("dd/MM/yyyy", cul));
                }
                else if (khangcao.LOAIKHANGCAO == 1) // quyết định
                {
                    APS_SOTHAM_QUYETDINH quyetdinhsotham = dt.APS_SOTHAM_QUYETDINH.Where(x => x.ID == khangcao.SOQDBA).FirstOrDefault<APS_SOTHAM_QUYETDINH>();
                    lblBaqd.InnerText = "Số " + quyetdinhsotham.SOQD + " ngày " + (string.IsNullOrEmpty(quyetdinhsotham.NGAYQD + "") ? "" : ((DateTime)quyetdinhsotham.NGAYQD).ToString("dd/MM/yyyy", cul));
                }
                else if (khangcao.LOAIKHANGCAO == 2) // quyết định khác
                {
                    APS_SOTHAM_QUYETDINH quyetdinhsotham = dt.APS_SOTHAM_QUYETDINH.Where(x => x.ID == khangcao.SOQDBA).FirstOrDefault<APS_SOTHAM_QUYETDINH>();
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
                if (ddlCanboThuly.SelectedValue == "0")
                {
                    lbthongBaoUpdateThuly.Text = "Bạn chưa chọn cán bộ thụ lý. Hãy chọn lại!";
                    ddlCanboThuly.Focus();
                    return;
                }

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
                oThuly.NGUOITHULYID = Convert.ToDecimal(ddlCanboThuly.SelectedValue);

                Decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";

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
            loadDDLHDXX();

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


        protected void btnClose_Click(object sender, EventArgs e)
        {
            hddKhangcaoID.Value = "";
            SOTHAM_KHANGCAO_ID = 0;

            resetThuly();
            resetHDXX();
            resetkKetqua();

            lbthongBaoUpdateThuly.Text = "";
            lbthongBaoUpdateHDXX.Text = "";
            lbthongBaoUpdateKetqua.Text = "";

            LoadGrid();
        }


    }
}