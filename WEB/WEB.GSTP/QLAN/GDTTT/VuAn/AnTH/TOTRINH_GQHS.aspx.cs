using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.AnTH
{
    public partial class TOTRINH_GQHS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    if (Request["hsid"] != null)
                    {
                        LoadThongtinQGTH();
                        Load_LoaiTrinh(ddlLoaitrinh, false, true);
                        Load_LoaiTrinh(dropCapTrinhTiep, true, true);
                        try
                        {
                            LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);
                            LoadLanhdao_TIEP(dropCapTrinhTiep, dropLDrinhTiep, lttLanhDao);
                        }
                        catch (Exception ex) { }
                    }

                }
            }
        }
        protected void cmdThem_Click(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// Lấy ra thông tin giải quyết xin ân giảm
        /// </summary>
        void LoadThongtinQGTH()
        {
            //ID của hồ sơ tử hình
            Decimal hs_ID = Convert.ToDecimal(Request["HSID"] + "");
            //Danh sach cac to trinh theo Hồ sơ id
            GDTTT_TUHINH_BL oBL2 = new GDTTT_TUHINH_BL();
            DataTable tbl_hs = null;
            tbl_hs = oBL2.DSTOTRINH_TUHINH(0, hs_ID);
            rpt.DataSource = tbl_hs;
            rpt.DataBind();

            // --Thong tin Bị án và Vụ án
            Decimal v_id = Convert.ToDecimal(Request["vid"] + "");
            LoadThongTinVuAn(v_id);
            //Đổ số SOTT và NGAYT và DXTTV của Tờ trình
            if (tbl_hs.Rows.Count > 0)
            {
                txtSototrinh.Text = Convert.ToString(tbl_hs.Rows[0]["SOTT"]);
                txtSototrinh.Enabled = (string.IsNullOrEmpty(Convert.ToString(tbl_hs.Rows[0]["SOTT"])) ? true : false);

                txtNgayTT.Text = (String.IsNullOrEmpty(tbl_hs.Rows[0]["NGAYTT"] + "") ? "" : ((DateTime)tbl_hs.Rows[0]["NGAYTT"]).ToString("dd/MM/yyyy", cul));
                txtNgayTT.Enabled = (string.IsNullOrEmpty(tbl_hs.Rows[0]["NGAYTT"] + "") ? true : false);

                txtDeXuatTTV.Text = Convert.ToString(tbl_hs.Rows[0]["DX_TTV"]);
                txtDeXuatTTV.Enabled = (string.IsNullOrEmpty(tbl_hs.Rows[0]["DX_TTV"] + "") ? true : false);

            }
        }


        /// <summary>
        /// Load thong tin vụ án từ bảng GDTTT_VUAN
        /// </summary>
        /// <param name="vuanid"> mã vụ án</param>
        void LoadThongTinVuAn(decimal vuanid)
        {

            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == vuanid).FirstOrDefault();
            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    lttVuAn.Text = oT.TENVUAN;
                else
                {
                    lttVuAn.Text = oT.NGUYENDON + " - " + oT.BIDON;
                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        lttVuAn.Text = lttVuAn.Text + " - " + oQHPL.TENQHPL;
                    }
                }

                //------------------------
                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);

            }
        }


        String Join_YKienDuyetTT(DataRow row)
        {
            string temp = "", temp_join;
            String YKienDuyetTT = "";

            temp = (row["CapTrinhTiep"] + "").Trim();
            YKienDuyetTT += String.IsNullOrEmpty(temp) ? "" : "Yêu cầu: " + temp;

            //-------------------------------------
            temp = (row["YKienLanhDao"] + "").Trim();
            if (String.IsNullOrEmpty(temp))
            {
                temp = (row["YKien"] + "").Trim();
                temp_join = String.IsNullOrEmpty(temp) ? "" : "Ý kiến: " + temp;
                if (YKienDuyetTT.Length > 0 && temp_join.Length > 0)
                    YKienDuyetTT += "<br/>";
                YKienDuyetTT += temp_join;
            }
            else
            {
                temp_join = "Ý kiến: <b>" + row["YKienLanhDao"] + "" + " </b>";
                if (YKienDuyetTT.Length > 0)
                    YKienDuyetTT += "<br/>";
                YKienDuyetTT += temp_join;

                temp = (row["YKien"] + "").Trim();
                YKienDuyetTT += String.IsNullOrEmpty(temp) ? "" : ", <span style='margin-left:5px;'>" + temp + "</span>";
            }
            //-------------------------------------
            temp = (row["Ghichu"] + "").Trim();
            temp_join = (String.IsNullOrEmpty(temp)) ? "" : ("Ghi chú: " + temp + "");
            if (YKienDuyetTT.Length > 0 && temp_join.Length > 0)
                YKienDuyetTT += "<br/>";
            YKienDuyetTT += temp_join;

            //-------------------------------------
            temp = (row["DX_TTV"] + "").Trim();
            temp_join = (String.IsNullOrEmpty(temp)) ? "" : ("Đề xuất TTV: " + temp);
            if (YKienDuyetTT.Length > 0 && temp_join.Length > 0)
                YKienDuyetTT += "<br/>";
            YKienDuyetTT += temp_join;

            //-------------------------------------
            return YKienDuyetTT;
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            //DataRowView dv = (DataRowView)e.Item.DataItem;
            //Literal lttSoTotrinh = (Literal)e.Item.FindControl("lttSoTotrinh");

            //if (dv["IsShow"].ToString() == "1")
            //{
            //    lttSoTotrinh.Visible = true;
            //lttSoTotrinh.Text = "<td rowspan='" + dv["Rowspan"].ToString() + "' style='text-align:center;'>" + dv["SOTT"].ToString() + " - " + dv["NGAYTT"].ToString() + " </td>";
            //}
            //else lttSoTotrinh.Visible = false;

        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ToTrinhID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    Load_Totrinh_sua(ToTrinhID);
                    cmdUpdate.Text = "Lưu";
                    cmdLamMoi.Text = "Hủy";

                    break;
                case "Xoa":

                    Xoa_ToTrinh(ToTrinhID);
                    Decimal hs_ID = Convert.ToDecimal(Request["HSID"] + "");
                    Load_Totrinh(hs_ID);
                    ResetControl();
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                    break;
            }

        }

        /// <summary>
        /// Load to trinh de sua
        /// </summary>
        /// <param name="ToTrinhID"></param>
        void Load_Totrinh(decimal hsID)
        {
            //Danh sach cac to trinh
            GDTTT_TUHINH_BL oBL2 = new GDTTT_TUHINH_BL();
            DataTable tbl2 = null;
            tbl2 = oBL2.DSTOTRINH_TUHINH(0, hsID);
            rpt.DataSource = tbl2;
            rpt.DataBind();

        }

        void Load_Totrinh_sua(decimal ToTrinhID)
        {
            TT_ID.Value = ToTrinhID.ToString();

            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            DataTable tbl = null;
            tbl = oBL.DSTOTRINH_TUHINH(ToTrinhID, 0);
            txtSototrinh.Text = Convert.ToString(tbl.Rows[0]["SOTT"]);
            txtNgayTT.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYTT"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYTT"]).ToString("dd/MM/yyyy", cul));
            txtDeXuatTTV.Text = Convert.ToString(tbl.Rows[0]["DX_TTV"]);

            Cls_Comon.SetValueComboBox(ddlLoaitrinh, tbl.Rows[0]["CAPTRINH"]);
            LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);
            if (ddlLanhdao.Visible && Convert.ToDecimal(tbl.Rows[0]["LANHDAOID"]) > 0)
                Cls_Comon.SetValueComboBox(ddlLanhdao, tbl.Rows[0]["LANHDAOID"]);

            txtNgaytrinh.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYTRINH"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYTRINH"]).ToString("dd/MM/yyyy", cul));
            txtNgayDangKyBC.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYDUKIENBC"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYDUKIENBC"]).ToString("dd/MM/yyyy", cul));
            txtNgayLDNhanToTrinh.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYNHANTT"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYNHANTT"]).ToString("dd/MM/yyyy", cul));
            txtNgaytra.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYTRATT"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYTRATT"]).ToString("dd/MM/yyyy", cul));
            rdLoaiYKien.Text = Convert.ToString(tbl.Rows[0]["LOAIYK"]);
            //dropCapTrinhTiep.SelectedValue = Convert.ToString(tbl.Rows[0]["CAPTRINHTIEP"]);
            //dropLDrinhTiep.SelectedValue = Convert.ToString(tbl.Rows[0]["TRINHTIEP_LANHDAO_ID"]);
            //dropLDrinhTiep.Visible = lttHoTenLDTiep.Visible = true;
            //Load_LoaiTrinh(dropCapTrinhTiep, true, true);


            Cls_Comon.SetValueComboBox(dropCapTrinhTiep, tbl.Rows[0]["CAPTRINHTIEP"]);
            LoadLanhdao_TIEP(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
            if (dropLDrinhTiep.Visible && Convert.ToDecimal(tbl.Rows[0]["TRINHTIEP_LANHDAO_ID"]) > 0)
                Cls_Comon.SetValueComboBox(dropLDrinhTiep, tbl.Rows[0]["TRINHTIEP_LANHDAO_ID"]);

            txtYkien.Text = Convert.ToString(tbl.Rows[0]["NOIDUNGYKIEN"]);
            txtGhichu.Text = Convert.ToString(tbl.Rows[0]["GHICHU"]);

        }
        void Xoa_ToTrinh(decimal ToTrinhID)
        {

            BL.GSTP.BANGSETGET.GDTTT_TOTRINH_TUHINH obj = new BL.GSTP.BANGSETGET.GDTTT_TOTRINH_TUHINH();
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            obj.ID = ToTrinhID;
            oBL.GDTTT_TOTRINH_TUHINH_DELETE(obj);
        }

        protected void chkEdit_CheckedChanged(object sender, EventArgs e)
        {
            if (chkEdit.Checked)
            {
                txtSototrinh.Enabled = true;
                txtNgayTT.Enabled = true;
                txtDeXuatTTV.Enabled = true;
            }
            else
            {
                txtSototrinh.Enabled = false;
                txtNgayTT.Enabled = false;
                txtDeXuatTTV.Enabled = false;
            }
        }


        protected void txtNgaylap_TextChanged(object sender, EventArgs e)
        {

        }

        protected void txtNgayTT_TextChanged(object sender, EventArgs e)
        {

        }

        protected void cmdPrint_Click(object sender, EventArgs e)
        {
        }
        protected void ddlLoaitrinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);
            decimal lantrinh = Convert.ToDecimal(ddlLoaitrinh.SelectedValue);
            if (lantrinh == 18)
            {

                GDTTT_TUHINH_BL oBL2 = new GDTTT_TUHINH_BL();
                DataTable tbl2 = null;
                Decimal hs_ID = Convert.ToDecimal(Request["HSID"] + "");
                tbl2 = oBL2.DSTOTRINH_TUHINH(0, hs_ID);
                string v_sott_ctn = null;
                foreach (DataRow row in tbl2.Rows)
                {
                    if (row["CAPTRINH"].ToString() == "18")
                        v_sott_ctn = row["CAPTRINH"].ToString();
                }

                //List<DAL.GSTP.GDTTT_TOTRINH_TUHINH> lst = null;
                //lst = dt.GDTTT_TOTRINH_TUHINH.Where(x => x.CAPTRINH == 18 
                //                                        && x.TUHINH_ID == hs_ID).ToList();

                //for (int i = 1; i < lst.Count; i++)
                //{
                //    v_sott_ctn = lst.
                //}

                if (v_sott_ctn == null)
                {
                    txtSototrinh.Enabled = txtNgayTT.Enabled = true;
                    txtSototrinh.Text = "";
                    txtNgayTT.Text = "";
                    txtDeXuatTTV.Text = "";
                }

            }
        }


        public void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ResetControl();
        }
        public void cmdHuyChon_Click(object sender, EventArgs e)
        {
            rdLoaiYKien.ClearSelection();
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (cmdUpdate.Text == "Lưu")
            {
                BL.GSTP.BANGSETGET.GDTTT_TOTRINH_TUHINH obj = new BL.GSTP.BANGSETGET.GDTTT_TOTRINH_TUHINH();

                obj.USER_ID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                obj.ID = Convert.ToDecimal(TT_ID.Value);
                // obj.TUHINH_ID = Convert.ToDecimal(Request["HSID"] + "");
                obj.SOTT = txtSototrinh.Text.Trim();
                obj.NGAYTT = DateTime.Parse(this.txtNgayTT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.DX_TTV = txtDeXuatTTV.Text.Trim();
                obj.CAPTRINH = Convert.ToDecimal(ddlLoaitrinh.SelectedValue);
                if (!string.IsNullOrEmpty(ddlLanhdao.SelectedValue))
                    obj.LANHDAOID = Convert.ToDecimal(ddlLanhdao.SelectedValue);
                // cần bắt với điều kiện null
                if (!string.IsNullOrEmpty(txtNgaytrinh.Text))
                    obj.NGAYTRINH = DateTime.Parse(this.txtNgaytrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (!string.IsNullOrEmpty(txtNgayDangKyBC.Text))
                    obj.NGAYDUKIENBC = DateTime.Parse(this.txtNgayDangKyBC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (!string.IsNullOrEmpty(txtNgayLDNhanToTrinh.Text))
                    obj.NGAYNHANTT = DateTime.Parse(this.txtNgayLDNhanToTrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (!string.IsNullOrEmpty(txtNgaytra.Text))
                    obj.NGAYTRATT = DateTime.Parse(this.txtNgaytra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (!string.IsNullOrEmpty(rdLoaiYKien.SelectedValue))
                    obj.LOAIYK = Convert.ToDecimal(rdLoaiYKien.SelectedValue);
                if (!string.IsNullOrEmpty(dropCapTrinhTiep.SelectedValue))
                    obj.CAPTRINHTIEP = Convert.ToDecimal(dropCapTrinhTiep.SelectedValue);
                if (!string.IsNullOrEmpty(dropLDrinhTiep.SelectedValue))
                    obj.TRINHTIEP_LANHDAO_ID = Convert.ToDecimal(dropLDrinhTiep.SelectedValue);

                obj.NOIDUNGYKIEN = txtYkien.Text.Trim();
                obj.GHICHU = txtGhichu.Text.Trim();

                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TOTRINH_TUHINH_INSERT_UPDAT(obj);

                cmdUpdate.Text = "Thêm mới";
                cmdLamMoi.Text = "Làm mới";

                //-- load lai to trinh
                ResetControl();
                Load_Totrinh(Convert.ToDecimal(Request["HSID"]));

            }
            else if (cmdUpdate.Text == "Thêm mới")
            {

                BL.GSTP.BANGSETGET.GDTTT_TOTRINH_TUHINH obj = new BL.GSTP.BANGSETGET.GDTTT_TOTRINH_TUHINH();

                obj.USER_ID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                obj.ID = 0;
                obj.TUHINH_ID = Convert.ToDecimal(Request["HSID"] + "");
                obj.SOTT = txtSototrinh.Text.Trim();
                obj.NGAYTT = DateTime.Parse(this.txtNgayTT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.DX_TTV = txtDeXuatTTV.Text.Trim();
                obj.CAPTRINH = Convert.ToDecimal(ddlLoaitrinh.SelectedValue);
                if (!string.IsNullOrEmpty(ddlLanhdao.SelectedValue))
                    obj.LANHDAOID = Convert.ToDecimal(ddlLanhdao.SelectedValue);
                // cần bắt với điều kiện null
                if (!string.IsNullOrEmpty(txtNgaytrinh.Text))
                    obj.NGAYTRINH = DateTime.Parse(this.txtNgaytrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (!string.IsNullOrEmpty(txtNgayDangKyBC.Text))
                    obj.NGAYDUKIENBC = DateTime.Parse(this.txtNgayDangKyBC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (!string.IsNullOrEmpty(txtNgayLDNhanToTrinh.Text))
                    obj.NGAYNHANTT = DateTime.Parse(this.txtNgayLDNhanToTrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (!string.IsNullOrEmpty(txtNgaytra.Text))
                    obj.NGAYTRATT = DateTime.Parse(this.txtNgaytra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (!string.IsNullOrEmpty(rdLoaiYKien.SelectedValue))
                    obj.LOAIYK = Convert.ToDecimal(rdLoaiYKien.SelectedValue);
                if (!string.IsNullOrEmpty(dropCapTrinhTiep.SelectedValue))
                    obj.CAPTRINHTIEP = Convert.ToDecimal(dropCapTrinhTiep.SelectedValue);
                if (!string.IsNullOrEmpty(dropLDrinhTiep.SelectedValue))
                    obj.TRINHTIEP_LANHDAO_ID = Convert.ToDecimal(dropLDrinhTiep.SelectedValue);

                obj.NOIDUNGYKIEN = txtYkien.Text.Trim();
                obj.GHICHU = txtGhichu.Text.Trim();

                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TOTRINH_TUHINH_INSERT_UPDAT(obj);

                //-- load lai to trinh
                ResetControl();
                Load_Totrinh(Convert.ToDecimal(Request["HSID"]));
                //Load_Totrinh(0);
            }
        }
        void Update_ToTrinh()
        {

        }


        protected void chkYeuCauKhac_CheckedChanged(object sender, EventArgs e)
        {

        }
        protected void dropCapTrinhTiep_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
        }
        //
        /// <summary>
        /// Lấy ra các cấp trình
        /// </summary>
        /// <param name="drop"></param>
        /// <param name="ShowChangeAll"></param>
        /// <param name="ShowNghienCuuBS"></param>
        void Load_LoaiTrinh(DropDownList drop, Boolean ShowChangeAll, Boolean ShowNghienCuuBS)
        {
            drop.Items.Clear();
            List<GDTTT_DM_TINHTRANG> lst = null;

            lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.GIAIDOAN == 2
                                                && x.ID != 10 && x.ID != 11 && x.ID != 100
                                                && x.HIEULUC == 1).OrderBy(x => x.THUTU).ToList();
            drop.DataSource = lst;
            drop.DataTextField = "TENTINHTRANG";
            drop.DataValueField = "ID";
            drop.DataBind();
            if (ShowChangeAll)
            {
                drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            }
            drop.Items.Insert(8, new ListItem("Trình Chủ Tịch Nước", "18"));

        }

        //---------------------------------
        /// <summary>
        /// lấy ra Lãnh đạo theo cấp trình tường ứng
        /// </summary>
        /// <param name="dropCapTrinh"></param>
        /// <param name="dropLanhDao"></param>
        /// <param name="lttHoTen"></param>
        private void LoadLanhdao(DropDownList dropCapTrinh, DropDownList dropLanhDao, Literal lttHoTen)
        {
            decimal TrangThaiID = Convert.ToDecimal(dropCapTrinh.SelectedValue);
            dropLanhDao.Items.Clear();
            if (TrangThaiID > 0)
            {
                lttHoTen.Visible = true;
                dropLanhDao.Visible = true;
                GDTTT_DON_BL objDon = new GDTTT_DON_BL();
                DM_CANBO_BL objCB = new DM_CANBO_BL();

                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal PBID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
                decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                GDTTT_DM_TINHTRANG oTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == TrangThaiID).FirstOrDefault();
                dropLanhDao.Items.Clear();

                switch (oTT.MA)
                {

                    case "07"://Phó chánh án
                        lttHoTen.Text = "Phó chánh án";
                        DataTable oCAPCA = objCB.DM_CANBO_GETBYDONVI_CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_PCA);
                        dropLanhDao.DataSource = oCAPCA;
                        dropLanhDao.DataTextField = "MA_TEN";
                        dropLanhDao.DataValueField = "ID";
                        dropLanhDao.DataBind();
                        break;
                    case "06":
                        //Tham phan
                        lttHoTen.Text = "Thẩm phán";
                        if (oT.THAMPHANID > 0)
                        {
                            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oT.THAMPHANID).FirstOrDefault();
                            dropLanhDao.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        }
                        else
                            dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    case "04":
                        //Phó Vụ trưởng
                        lttHoTen.Text = "Phó Vụ trưởng";
                        if (oT.LANHDAOVUID > 0)
                        {
                            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oT.LANHDAOVUID).FirstOrDefault();
                            dropLanhDao.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        }
                        else
                            dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    case "05":
                        //Vụ trưởng
                        lttHoTen.Text = "Vụ trưởng";
                        DataTable tblVT = objDon.CANBO_GETBYDONVI_2CHUCVU(DonViID, PBID, ENUM_CHUCVU.CHUCVU_VT, ENUM_CHUCVU.CHUCVU_VT);
                        dropLanhDao.DataSource = tblVT;
                        dropLanhDao.DataTextField = "MA_TEN";
                        dropLanhDao.DataValueField = "ID";
                        dropLanhDao.DataBind();
                        if (dropLanhDao.Items.Count == 0)
                            dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    default:
                        lttHoTen.Visible = false;
                        dropLanhDao.Visible = false;
                        break;
                }

            }
            else
            {
                dropLanhDao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                lttHoTen.Text = "Lãnh đạo";
            }
        }
        private void LoadLanhdao_TIEP(DropDownList dropCapTrinhTiep, DropDownList dropLanhDaoTiep, Literal lttHoTen)
        {
            decimal TrangThaiID = Convert.ToDecimal(dropCapTrinhTiep.SelectedValue);
            dropLDrinhTiep.Items.Clear();
            if (TrangThaiID > 0)
            {
                lttHoTen.Visible = true;
                dropLDrinhTiep.Visible = true;
                GDTTT_DON_BL objDon = new GDTTT_DON_BL();
                DM_CANBO_BL objCB = new DM_CANBO_BL();

                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal PBID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
                decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                GDTTT_DM_TINHTRANG oTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == TrangThaiID).FirstOrDefault();
                dropLDrinhTiep.Items.Clear();
                switch (oTT.MA)
                {
                    case "07"://Phó chánh án
                        lttHoTen.Text = "Phó chánh án";
                        DataTable oCAPCA = objCB.DM_CANBO_GETBYDONVI_CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_PCA);
                        dropLDrinhTiep.DataSource = oCAPCA;
                        dropLDrinhTiep.DataTextField = "MA_TEN";
                        dropLDrinhTiep.DataValueField = "ID";
                        dropLDrinhTiep.DataBind();
                        break;
                    case "06":
                        //Tham phan
                        lttHoTen.Text = "Thẩm phán";
                        if (oT.THAMPHANID > 0)
                        {
                            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oT.THAMPHANID).FirstOrDefault();
                            dropLDrinhTiep.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        }
                        else
                            dropLDrinhTiep.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    case "04":
                        //Phó Vụ trưởng
                        lttHoTen.Text = "Phó Vụ trưởng";
                        if (oT.LANHDAOVUID > 0)
                        {
                            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oT.LANHDAOVUID).FirstOrDefault();
                            dropLDrinhTiep.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        }
                        else
                            dropLDrinhTiep.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    case "05":
                        //Vụ trưởng
                        lttHoTen.Text = "Vụ trưởng";
                        DataTable tblVT = objDon.CANBO_GETBYDONVI_2CHUCVU(DonViID, PBID, ENUM_CHUCVU.CHUCVU_VT, ENUM_CHUCVU.CHUCVU_VT);
                        dropLDrinhTiep.DataSource = tblVT;
                        dropLDrinhTiep.DataTextField = "MA_TEN";
                        dropLDrinhTiep.DataValueField = "ID";
                        dropLDrinhTiep.DataBind();
                        if (dropLDrinhTiep.Items.Count == 0)
                            dropLDrinhTiep.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    default:
                        lttHoTen.Visible = false;
                        dropLDrinhTiep.Visible = false;
                        break;
                }
            }
            else
            {
                dropLDrinhTiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                lttHoTen.Text = "Lãnh đạo";
            }
        }
        //---------------------------------
        void check_is_ThamPhan()
        {
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                    {
                        //----------------------
                        txtNgayLDNhanToTrinh.Focus();
                        txtSototrinh.Enabled = false;
                        txtNgayTT.Enabled = false;
                        chkEdit.Enabled = false;
                        txtDeXuatTTV.Enabled = false;
                        ddlLoaitrinh.Enabled = false;
                        ddlLanhdao.Enabled = false;
                        txtNgaytrinh.Enabled = false;
                        txtNgayDangKyBC.Enabled = false;
                        //----------------------
                        txtNgaytra.Enabled = true;
                        txtNgayLDNhanToTrinh.Enabled = true;
                        //chkTrinhLai.Enabled = false;

                        rdLoaiYKien.Enabled = true;
                        cmdHuyChon.Enabled = true;
                        dropCapTrinhTiep.Enabled = true;
                        dropLDrinhTiep.Enabled = true;
                        txtYkien.Enabled = true;
                        txtGhichu.Enabled = true;
                    }
                    else  //--------ttv--------------
                    {
                        txtSototrinh.Focus();
                        txtSototrinh.Enabled = true;
                        txtNgayTT.Enabled = true;
                        txtDeXuatTTV.Enabled = true;
                        ddlLoaitrinh.Enabled = true;
                        ddlLanhdao.Enabled = true;
                        txtNgaytrinh.Enabled = true;
                        chkEdit.Enabled = true;
                        txtNgayDangKyBC.Enabled = true;
                        //----------------------
                        txtNgaytra.Enabled = true;
                        txtNgayLDNhanToTrinh.Enabled = true;
                        //chkTrinhLai.Enabled = true;

                        rdLoaiYKien.Enabled = true;
                        cmdHuyChon.Enabled = true;
                        dropCapTrinhTiep.Enabled = true;
                        dropLDrinhTiep.Enabled = true;
                        txtYkien.Enabled = true;
                        txtGhichu.Enabled = true;
                    }

                }

            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        //---------------------------
        private void ResetControl()
        {
            if (!string.IsNullOrEmpty(txtSototrinh.Text))
                txtSototrinh.Enabled = false;
            if (!string.IsNullOrEmpty(txtNgayTT.Text))
                txtNgayTT.Enabled = false;
            if (!string.IsNullOrEmpty(txtDeXuatTTV.Text))
                txtDeXuatTTV.Enabled = false;

            txtNgaytra.Text = txtNgaytrinh.Text = txtGhichu.Text = txtYkien.Text = "";
            ddlLoaitrinh.SelectedIndex = 0;
            LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);
            chkEdit.Checked = false;
            //chkEdit.Checked = chkTrinhLai.Checked = false;
            TT_ID.Value = "0";
            pnTrinhLDTiep.Visible = false;
            dropCapTrinhTiep.SelectedIndex = 0;
            LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
            txtNgaytrinh.Text = null;
            txtNgayDangKyBC.Text = null;
            txtNgayLDNhanToTrinh.Text = null;
            txtNgaytra.Text = null;

            rdLoaiYKien.ClearSelection();

            pnTrinhLDTiep.Visible = true;
            txtYkien.Text = null;
            txtGhichu.Text = null;

        }


    }
}