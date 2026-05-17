using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;
using BL.GSTP.ADS;
using BL.GSTP.BANGSETGET.APS;
using BL.GSTP.BANGSETGET.XLHC;
using System.Text;
using BL.GSTP.BANGSETGET;
using Oracle.ManagedDataAccess.Client;


namespace WEB.GSTP.QLAN
{
    public partial class CapnhatHinhthucxetxu : System.Web.UI.Page
    {
        //--------------------------------
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrDonViID;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            if (!IsPostBack)
            {
                DateTime start_date = DateTime.Today.AddMonths(0);//0 lấy tháng hiện tại;-1 lấy 1 tháng trở về trước tính từ ngày hiện tại
                string strDate = "01" + start_date.ToString("/MM/yyyy");
                txtThuly_Tu.Text = strDate;
                txtThuly_Den.Text = DateTime.Now.ToString("dd/MM/yyyy");

                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID > 0)
                {
                    DM_TOAAN objDV = dt.DM_TOAAN.Where(x => x.ID == CurrDonViID).FirstOrDefault();
                    String str_typeusers = objDV.LOAITOA;
                    Session["LOAITOA"] = objDV.LOAITOA;
                }
            }
        }

        protected void ddlLoaiChucnang_SelectedIndexChanged(object sender, EventArgs e)
        {

            if (ddlLoaiChucnang.SelectedValue == "0")
            {
                pnTrangchinh.Visible = true;
                pnBaocao.Visible = false;
                pnCapnhatXXTT.Visible = false;
                pnTimkiemHTXX.Visible = false;
            }
            else if (ddlLoaiChucnang.SelectedValue == "1") // Báo cáo tình hình xét xử trực tuyến
            {
                pnTrangchinh.Visible = false;
                pnBaocao.Visible = true;
                pnCapnhatXXTT.Visible = pnTimkiemHTXX.Visible = false;

            }
            else if (ddlLoaiChucnang.SelectedValue == "2") // Cập nhật tình hình xét xử trực tuyến
            {
                pnTrangchinh.Visible = false;
                pnBaocao.Visible = false;
                pnCapnhatXXTT.Visible = pnTimkiemHTXX.Visible = true;


                txtToaAn.Text = Convert.ToString(Session[ENUM_SESSION.SESSION_TENDONVI]);
                LoadCombobox(ddlCapxx);
                LoadGrid();
            }
        }

        #region Cập nhật hình thức xét xử

        #region Load dropdownlist

        void LoadCombobox(DropDownList e)
        {
            e.Items.Clear();
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                ddlCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                e.Items.Add(new ListItem("-- Tất cả --", "0"));
                e.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                e.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                e.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                e.Items.Add(new ListItem("-- Tất cả --", "0"));
                e.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                e.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }

            LoadDropThamphan(ddlTimkiemHTXX_Chutoa);
            LoadDropThamphan(ddlChutoa);
            LoadDrop_TTV_TK(lbThuky);
        }

        void LoadDropThamphan(DropDownList e)
        {
            Boolean IsLoadAll = true;

            e.Items.Clear();

            //e.Items.Add(new ListItem("-- Chọn --", "0"));

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            // Kiểm tra nếu user login là thẩm phán thì chỉ load 1 user
            // nếu là chánh án, phó chánh án hoặc khác thẩm phán thì load all
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            //Kiểm tra cán bộ thuộc tòa án hay là biệt phái
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID && x.TOAANID == ToaAnID).FirstOrDefault<DM_CANBO>();
            DM_CANBO_BIETPHAI oCBBP = dt.DM_CANBO_BIETPHAI.Where(x => x.CANBOID == CanboID && x.TOAANID == ToaAnID).FirstOrDefault<DM_CANBO_BIETPHAI>();
            if (oCB != null)
            {
                //Là cán bộ tòa
                // Kiểm tra chức danh có là thẩm phán hay không
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA.Contains("TP"))
                    {
                        e.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        IsLoadAll = false;
                    }
                }
                // Kiểm tra chức vụ có là Chánh án hoặc phó chánh án hay không
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCD.MA.Contains("CA"))
                    {
                        IsLoadAll = true;
                    }
                }
            }

            if (oCBBP != null)
            {
                //là cán bộ biệt phái
                DM_CANBO CBBP = dt.DM_CANBO.Where(x => x.ID == CanboID && x.TOAANID != ToaAnID).FirstOrDefault<DM_CANBO>();
                // Kiểm tra chức danh có là thẩm phán hay không
                if (CBBP != null)
                    if (CBBP.CHUCDANHID != null && CBBP.CHUCDANHID != 0)
                    {
                        DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == CBBP.CHUCDANHID).FirstOrDefault();
                        if (oCD.MA.Contains("TP"))
                        {
                            e.Items.Add(new ListItem(CBBP.HOTEN, CBBP.ID.ToString()));
                            IsLoadAll = false;
                        }
                    }
            }

            if (IsLoadAll)
            {
                DM_CANBO_BL objBL = new DM_CANBO_BL();

                decimal toaanid = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(toaanid, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                e.DataSource = tbl;
                e.DataTextField = "HOTEN";
                e.DataValueField = "ID";
                e.DataBind();
            }

            e.Items.Add(new ListItem("-- Chọn --", "0"));
            e.SelectedValue = "0";
        }

        protected void LoadDrop_TTV_TK(ListBox e)
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;

            decimal toaanid = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            tbl = objBL.GET_ThuKy_TTVS(Convert.ToString(toaanid), null);

            e.Items.Clear();
            if (tbl != null)
            {
                int count_item = tbl.Columns.Count;
                if (count_item > 0)
                {
                    e.DataSource = tbl;
                    e.DataTextField = "MA_TEN";
                    e.DataValueField = "ID";
                    e.DataBind();
                }
            };
        }
        #endregion




        #region Các Action
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;

                if (ddlXXTTLoaian.SelectedValue == "7")
                {
                    APS_CAPNHAT_HTXX oND;
                    if ((hddid.Value == "" || hddid.Value == "0"))
                    {
                        oND = new APS_CAPNHAT_HTXX();
                    }
                    else
                    {
                        decimal ID = Convert.ToDecimal(hddid.Value);
                        oND = DataExtensions.FindById<APS_CAPNHAT_HTXX>(ID);
                    }

                    oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oND.MAGIAIDOAN = Convert.ToDecimal(ddlCapxx.SelectedValue);
                    oND.CHUTOAID = Convert.ToDecimal(ddlChutoa.SelectedValue);

                    string listThuky = "";
                    if (lbThuky.Items.Count > 0)
                    {
                        for (int i = 0; i < lbThuky.Items.Count; i++)
                        {
                            if (lbThuky.Items[i].Selected)
                            {
                                listThuky = listThuky + lbThuky.Items[i].Value + ",";
                            }
                        }
                    }
                    oND.THUKY_IDS = listThuky;
                    
                    if (!String.IsNullOrEmpty(txtNgayxetxu.Text))
                    {
                        oND.NGAYXETXU = DateTime.Parse(this.txtNgayxetxu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }

                    oND.TENVUAN = txtTenVuViec.Text;

                    oND.PHONGXETXU = txtPhongxetxu.Text;
                    oND.DIEMCAU_1 = txtDiemcauthanhphan1.Text;
                    oND.DIEMCAU_2 = txtDiemcauthanhphan2.Text;

                    oND.LOAIBAQD = Convert.ToDecimal(ddlBAQD.SelectedValue);
                    oND.SOBAQD = txtSoBAQD.Text;
                    if (!String.IsNullOrEmpty(txtNgayBAQD.Text))
                    {
                        oND.NGAYBAQD = DateTime.Parse(this.txtNgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
                    }

                    oND.TRANGTHAI = Convert.ToDecimal(ddlTrangthai.SelectedValue);
                    oND.GHICHU = txtGhichu.Text;


                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Insert(oND);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Update(oND);
                    }
                }
                else if (ddlXXTTLoaian.SelectedValue == "8")
                {
                    XLHC_CAPNHAT_HTXX oND;
                    if ((hddid.Value == "" || hddid.Value == "0"))
                    {
                        oND = new XLHC_CAPNHAT_HTXX();
                    }
                    else
                    {
                        decimal ID = Convert.ToDecimal(hddid.Value);
                        oND = DataExtensions.FindById<XLHC_CAPNHAT_HTXX>(ID);
                    }

                    oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oND.MAGIAIDOAN = Convert.ToDecimal(ddlCapxx.SelectedValue);
                    oND.CHUTOAID = Convert.ToDecimal(ddlChutoa.SelectedValue);

                    string listThuky = "";
                    if (lbThuky.Items.Count > 0)
                    {
                        for (int i = 0; i < lbThuky.Items.Count; i++)
                        {
                            if (lbThuky.Items[i].Selected)
                            {
                                listThuky = listThuky + lbThuky.Items[i].Value + ",";
                            }
                        }
                    }
                    oND.THUKY_IDS = listThuky;
                    
                    if (!String.IsNullOrEmpty(txtNgayxetxu.Text))
                    {
                        oND.NGAYXETXU = DateTime.Parse(this.txtNgayxetxu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }

                    oND.TENVUAN = txtTenVuViec.Text;

                    oND.PHONGXETXU = txtPhongxetxu.Text;
                    oND.DIEMCAU_1 = txtDiemcauthanhphan1.Text;
                    oND.DIEMCAU_2 = txtDiemcauthanhphan2.Text;

                    oND.LOAIBAQD = Convert.ToDecimal(ddlBAQD.SelectedValue);
                    oND.SOBAQD = txtSoBAQD.Text;
                    if (!String.IsNullOrEmpty(txtNgayBAQD.Text))
                    {
                        oND.NGAYBAQD = DateTime.Parse(this.txtNgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }

                    oND.TRANGTHAI = Convert.ToDecimal(ddlTrangthai.SelectedValue);
                    oND.GHICHU = txtGhichu.Text;


                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Insert(oND);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Update(oND);
                    }
                }


                ddlTimkiemHTXX_Loaian.SelectedValue = ddlXXTTLoaian.SelectedValue;
                ddlTimkiemHTXX_Trangthai.SelectedValue = ddlTrangthai.SelectedValue;

                dgList.CurrentPageIndex = 0;
                LoadGrid();
                
                lbthongbao.Text = "Lưu thành công!";
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }

        public void loadedit(decimal ID, decimal LOAIAN)
        {
            hddid.Value = ID.ToString();
            if (LOAIAN == 7)
            {
                var oND = DataExtensions.FindById<APS_CAPNHAT_HTXX>(ID);

                try
                {

                    txtToaAn.Text = Session[ENUM_SESSION.SESSION_TENDONVI].ToString();
                    ddlXXTTLoaian.SelectedValue = hddLoaianLoadedit.Value;
                    ddlCapxx.SelectedValue = string.IsNullOrEmpty(oND.MAGIAIDOAN + "") ? "" : oND.MAGIAIDOAN.ToString().Equals("") ? "" : oND.MAGIAIDOAN.ToString();
                    ddlChutoa.SelectedValue = string.IsNullOrEmpty(oND.CHUTOAID + "") ? "" : oND.CHUTOAID.ToString().Equals("") ? "" : oND.CHUTOAID.ToString();

                    LoadDrop_TTV_TK(lbThuky);
                    if (oND.THUKY_IDS != null)
                    {
                        try
                        {
                            string[] dsThuky = oND.THUKY_IDS.Split(',');
                            foreach (string item in dsThuky)
                            {
                                lbThuky.Items.FindByValue(item).Selected = true;
                            }
                        }
                        catch (Exception ex) { /*lbthongbao.Text = "Lỗi: Danh sách thư ký." + ex.Message;*/ }
                    }
                    txtTenVuViec.Text = oND.TENVUAN.ToString();
                    txtNgayxetxu.Text = string.IsNullOrEmpty(oND.NGAYXETXU + "") ? "" : ((DateTime)oND.NGAYXETXU).ToString("dd/MM/yyyy", cul);

                    txtPhongxetxu.Text = string.IsNullOrEmpty(oND.PHONGXETXU + "") ? "" : oND.PHONGXETXU.ToString().Equals("") ? "" : oND.PHONGXETXU.ToString();
                    txtDiemcauthanhphan1.Text = string.IsNullOrEmpty(oND.DIEMCAU_1 + "") ? "" : oND.DIEMCAU_1.ToString().Equals("") ? "" : oND.DIEMCAU_1.ToString();
                    txtDiemcauthanhphan2.Text = string.IsNullOrEmpty(oND.DIEMCAU_2 + "") ? "" : oND.DIEMCAU_2.ToString().Equals("") ? "" : oND.DIEMCAU_2.ToString();

                    ddlBAQD.SelectedValue = string.IsNullOrEmpty(oND.LOAIBAQD + "") ? "" : oND.LOAIBAQD.ToString().Equals("") ? "" : oND.LOAIBAQD.ToString();
                    txtSoBAQD.Text = string.IsNullOrEmpty(oND.SOBAQD + "") ? "" : oND.SOBAQD.ToString().Equals("") ? "" : oND.SOBAQD.ToString();
                    txtNgayBAQD.Text = string.IsNullOrEmpty(oND.NGAYBAQD + "") ? "" : ((DateTime)oND.NGAYBAQD).ToString("dd/MM/yyyy", cul);

                    ddlTrangthai.SelectedValue = string.IsNullOrEmpty(oND.TRANGTHAI + "") ? "" : oND.TRANGTHAI.ToString().Equals("") ? "" : oND.TRANGTHAI.ToString();
                    txtGhichu.Text = string.IsNullOrEmpty(oND.GHICHU + "") ? "" : oND.GHICHU.ToString().Equals("") ? "" : oND.GHICHU.ToString();
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = "Lỗi: " + ex.Message;
                }
            }
            else if (LOAIAN == 8)
            {
                var oND = DataExtensions.FindById<XLHC_CAPNHAT_HTXX>(ID);

                try
                {

                    txtToaAn.Text = Session[ENUM_SESSION.SESSION_TENDONVI].ToString();
                    ddlXXTTLoaian.SelectedValue = hddLoaianLoadedit.Value;
                    ddlCapxx.SelectedValue = string.IsNullOrEmpty(oND.MAGIAIDOAN + "") ? "" : oND.MAGIAIDOAN.ToString().Equals("") ? "" : oND.MAGIAIDOAN.ToString();
                    ddlChutoa.SelectedValue = string.IsNullOrEmpty(oND.CHUTOAID + "") ? "" : oND.CHUTOAID.ToString().Equals("") ? "" : oND.CHUTOAID.ToString();

                    LoadDrop_TTV_TK(lbThuky);
                    try
                    {
                        string[] dsThuky = oND.THUKY_IDS.Split(',');
                        foreach (string item in dsThuky)
                        {
                            lbThuky.Items.FindByValue(item).Selected = true;
                        }
                    }
                    catch { }

                    txtTenVuViec.Text = oND.TENVUAN.ToString();
                    txtNgayxetxu.Text = string.IsNullOrEmpty(oND.NGAYXETXU + "") ? "" : ((DateTime)oND.NGAYXETXU).ToString("dd/MM/yyyy", cul);

                    txtPhongxetxu.Text = string.IsNullOrEmpty(oND.PHONGXETXU + "") ? "" : oND.PHONGXETXU.ToString().Equals("") ? "" : oND.PHONGXETXU.ToString();
                    txtDiemcauthanhphan1.Text = string.IsNullOrEmpty(oND.DIEMCAU_1 + "") ? "" : oND.DIEMCAU_1.ToString().Equals("") ? "" : oND.DIEMCAU_1.ToString();
                    txtDiemcauthanhphan2.Text = string.IsNullOrEmpty(oND.DIEMCAU_2 + "") ? "" : oND.DIEMCAU_2.ToString().Equals("") ? "" : oND.DIEMCAU_2.ToString();

                    ddlBAQD.SelectedValue = string.IsNullOrEmpty(oND.LOAIBAQD + "") ? "" : oND.LOAIBAQD.ToString().Equals("") ? "" : oND.LOAIBAQD.ToString();
                    txtSoBAQD.Text = string.IsNullOrEmpty(oND.SOBAQD + "") ? "" : oND.SOBAQD.ToString().Equals("") ? "" : oND.SOBAQD.ToString();
                    txtNgayBAQD.Text = string.IsNullOrEmpty(oND.NGAYBAQD + "") ? "" : ((DateTime)oND.NGAYBAQD).ToString("dd/MM/yyyy", cul);

                    ddlTrangthai.SelectedValue = string.IsNullOrEmpty(oND.TRANGTHAI + "") ? "" : oND.TRANGTHAI.ToString().Equals("") ? "" : oND.TRANGTHAI.ToString();
                    txtGhichu.Text = string.IsNullOrEmpty(oND.GHICHU + "") ? "" : oND.GHICHU.ToString().Equals("") ? "" : oND.GHICHU.ToString();
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = "Lỗi: " + ex.Message;
                }
            }
        }

        public void xoa(decimal id, decimal LOAIAN)
        {
            if (LOAIAN == 7)
            {
                APS_CAPNHAT_HTXX oND = DataExtensions.FindById<APS_CAPNHAT_HTXX>(id);
                if (oND != null)
                {
                    DataExtensions.Delete(oND);

                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                    ResetControls();
                    lbthongbao.Text = "Xóa thành công!";
                }
            }
            else if (LOAIAN == 8)
            {
                XLHC_CAPNHAT_HTXX oND = DataExtensions.FindById<XLHC_CAPNHAT_HTXX>(id);
                if (oND != null)
                {
                    DataExtensions.Delete(oND);

                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                    ResetControls();
                    lbthongbao.Text = "Xóa thành công!";
                }
            }
            return;
        }

        protected void cmdTimkiemHTXX_Click(object sender, EventArgs e)
        {
            LoadGrid();
        }

        #endregion




        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {

            string[] commandArgs = e.CommandArgument.ToString().Split(new char[] { ',' });
            hddid.Value = commandArgs[0].ToString();
            hddLoaianLoadedit.Value = commandArgs[1].ToString();

            decimal ND_id = Convert.ToDecimal(commandArgs[0].ToString());
            decimal ND_loaian = Convert.ToDecimal(commandArgs[1].ToString());

            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id, ND_loaian);

                    break;

                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(ND_id, ND_loaian);
                    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
            }
        }

        public void LoadGrid()
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("VTOAANID",Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])),
                        new OracleParameter("VLOAIAN",Convert.ToDecimal(ddlTimkiemHTXX_Loaian.SelectedValue)),
                        new OracleParameter("VTRANGTHAI",Convert.ToDecimal(ddlTimkiemHTXX_Trangthai.SelectedValue)),
                        
                        new OracleParameter("VCHUTOA",ddlTimkiemHTXX_Chutoa.SelectedValue),

                        new OracleParameter("VBAQDTUNGAY",txtTimkiemHTXX_BAQD_TuNgay.Text.Trim()),
                        new OracleParameter("VBAQDDENNGAY",txtTimkiemHTXX_BAQD_DenNgay.Text.Trim()),

                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };

                DataTable oDT = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_HINHTHUCXETXU.DANHSACH_CAPNHAT_HINHTHUCXETXU", parameters);
                int count_all = 0, page_size = 20;
                if (oDT.Rows.Count > 0)
                {
                    #region "Xác định số lượng trang"
                    count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                    #endregion
                }
                else
                {
                    hddTotalPage.Value = "1";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                               lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                }
                dgList.PageSize = page_size;
                dgList.DataSource = oDT;
                dgList.DataBind();
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        lbthongbao.Text = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
            }
        }

        void ResetControls()
        {
            try
            {
                LoadCombobox(ddlCapxx);
                ddlChutoa.SelectedValue = "0";
                lbThuky.ClearSelection();
                txtNgayxetxu.Text = "";
                txtTenVuViec.Text = "";
                txtPhongxetxu.Text = "";
                txtDiemcauthanhphan1.Text = "";
                txtDiemcauthanhphan2.Text = "";
                ddlBAQD.SelectedValue = "0";
                txtSoBAQD.Text = "";
                txtNgayBAQD.Text = "";
                ddlTrangthai.SelectedValue = "1";
                txtGhichu.Text = "";
                hddid.Value = "0";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        bool CheckValid()
        {
            if (ddlCapxx.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn cấp xét xử";
                ddlCapxx.Focus();
                return false;
            }

            if (ddlChutoa.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn chủ tọa phiên tòa";
                ddlChutoa.Focus();
                return false;
            }

            if (txtNgayxetxu.Text == "")
            {
                lbthongbao.Text = "Chưa nhập ngày xét xử";
                txtNgayxetxu.Focus();
                return false;
            }

            if (txtTenVuViec.Text == "")
            {
                lbthongbao.Text = "Chưa nhập tên vụ án/ vụ việc";
                txtTenVuViec.Focus();
                return false;
            }

            if(ddlBAQD.SelectedValue != "0" || txtSoBAQD.Text != "" || txtNgayBAQD.Text != "")
            {
                if(ddlBAQD.SelectedValue == "0")
                {
                    lbthongbao.Text = "Hãy chọn loại bản án hoặc quyết định";
                    ddlBAQD.Focus();
                    return false;
                }
                if (txtSoBAQD.Text == "")
                {
                    lbthongbao.Text = "Chưa nhập số bản án/quyết định";
                    txtSoBAQD.Focus();
                    return false;
                }
                if (txtNgayBAQD.Text == "")
                {
                    lbthongbao.Text = "Chưa nhập ngày bản án/quyết định";
                    txtNgayBAQD.Focus();
                    return false;
                }
            }

            return true;
        }

        //protected void ddlBAQD_SelectedIndexChanged(object sender, EventArgs e)
        //{

        //    if (ddlBAQD.SelectedValue == "0")
        //    {
        //        ltSoBAQD.Text = "";
        //        ltNgayBAQD.Text = "";
        //    }
        //    else if (ddlBAQD.SelectedValue == "1") // Báo cáo tình hình xét xử trực tuyến
        //    {
        //        ltSoBAQD.Text = "<span style='color:red'>(*)</span>";
        //        ltNgayBAQD.Text = "<span style='color:red'>(*)</span>";
        //    }
        //    else if (ddlBAQD.SelectedValue == "2") // Cập nhật tình hình xét xử trực tuyến
        //    {
        //        ltSoBAQD.Text = "<span style='color:red'>(*)</span>";
        //        ltNgayBAQD.Text = "<span style='color:red'>(*)</span>";
        //    }
        //}

        #endregion

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }
        #endregion

























        public void Get_Courts_Options()
        {
            String str_typeusers = Session["LOAITOA"].ToString();
            DM_TOAAN_BL qtBL = new DM_TOAAN_BL();
            DataTable oDT = new DataTable();
            oDT = qtBL.QT_Donvi_TA_BC(str_typeusers, Drop_object.SelectedValue);
            Getdata_Courts(oDT);
        }

        protected void btn_NhapMoi_Click(object sender, EventArgs e)
        {
            txtThuly_Tu.Text = string.Empty;
            txtThuly_Den.Text = string.Empty;
            reset_DropCourt();
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            if (txtThuly_Tu.Text == "")
            {
                lblmsg.Text = "Bạn phải nhập từ ngày.";
                return;
            }
            if (txtThuly_Den.Text == "")
            {
                lblmsg.Text = "Bạn phải nhập đến ngày.";
                return;
            }
            if (ddlLoaiBaocao.SelectedValue == "1")
            {
                //LoadReport_bcpt_1();//Tổng hợp số liệu
            }
            else if (ddlLoaiBaocao.SelectedValue == "2")
            {
                LoadReport_baocao_Hinhthucxetxu_Tinhhuyen();
            }
            else if (ddlLoaiBaocao.SelectedValue == "3")
            {
                LoadReport_baocao_Hinhthucxetxu_Canbo();
            }
        }
        private bool CheckData()
        {
            string TuNgay = txtThuly_Tu.Text, DenNgay = txtThuly_Den.Text;
            if (TuNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập từ ngày.";
                Cls_Comon.SetFocus(this.txtThuly_Tu, this.GetType(), txtThuly_Tu.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập từ ngày chưa đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtThuly_Tu, this.GetType(), txtThuly_Tu.ClientID);
                    return false;
                }
            }
            if (DenNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập đến ngày.";
                Cls_Comon.SetFocus(this.txtThuly_Den, this.GetType(), txtThuly_Den.ClientID);
                return false;
            }
            if (DenNgay != "")
            {
                DateTime Day_DenNgay = DateTime.Now;
                if (DateTime.TryParse(DenNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_DenNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập đến ngày đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtThuly_Den, this.GetType(), txtThuly_Den.ClientID);
                    return false;
                }
            }
            if (TuNgay != "" && DenNgay != "")
            {
                if (DateTime.Parse(txtThuly_Tu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault) > DateTime.Parse(txtThuly_Den.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
                {
                    lblmsg.Text = "Từ ngày phải nhỏ hơn hoặc bằng đến ngày.";
                    return false;
                }
            }
            return true;
        }
        private string AddExcelStyling(Int32 landscape, String INSERT_PAGE_BREAK)
        {
            // add the style props to get the page orientation
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'\n" +
            "xmlns:x='urn:schemas-microsoft-com:office:excel'\n" +
            "xmlns='http://www.w3.org/TR/REC-html40'>\n" +
            "<head>\n");
            sb.Append("<style>\n");
            sb.Append("@page");
            //page margin can be changed based on requirement.....            
            //sb.Append("{margin:0.5in 0.2992125984in 0.5in 0.5984251969in;\n");
            sb.Append("{margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;\n");
            sb.Append("mso-header-margin:.5in;\n");
            sb.Append("mso-footer-margin:.5in;\n");
            if (landscape == 2)//landscape orientation
            {
                sb.Append("mso-page-orientation:landscape;}\n");
            }
            sb.Append("</style>\n");
            sb.Append("<!--[if gte mso 9]><xml>\n");
            sb.Append("<x:ExcelWorkbook>\n");
            sb.Append("<x:ExcelWorksheets>\n");
            sb.Append("<x:ExcelWorksheet>\n");
            sb.Append("<x:Name>Projects 3 </x:Name>\n");
            sb.Append("<x:WorksheetOptions>\n");
            sb.Append("<x:Print>\n");
            sb.Append("<x:ValidPrinterInfo/>\n");
            sb.Append("<x:PaperSizeIndex>9</x:PaperSizeIndex>\n");
            sb.Append("<x:HorizontalResolution>600</x:HorizontalResolution\n");
            sb.Append("<x:VerticalResolution>600</x:VerticalResolution\n");
            sb.Append("</x:Print>\n");
            sb.Append("<x:Selected/>\n");
            sb.Append("<x:DoNotDisplayGridlines/>\n");
            sb.Append("<x:ProtectContents>False</x:ProtectContents>\n");
            sb.Append("<x:ProtectObjects>False</x:ProtectObjects>\n");
            sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>\n");
            sb.Append("</x:WorksheetOptions>\n");
            //-------------
            if (INSERT_PAGE_BREAK != null)
            {
                sb.Append("<x:PageBreaks> xmlns='urn:schemas-microsoft-com:office:excel'\n");
                sb.Append("<x:RowBreaks>\n");
                String[] rows_ = INSERT_PAGE_BREAK.Split(',');
                String Append_s = "";
                for (int i = 0; i < rows_.Length; i++)
                {
                    Append_s = Append_s + "<x:RowBreak><x:Row>" + rows_[i] + "</x:Row></x:RowBreak>\n";
                }
                sb.Append(Append_s);
                sb.Append("</x:RowBreaks>\n");
                sb.Append("</x:PageBreaks>\n");
            }
            //----------
            sb.Append("</x:ExcelWorksheet>\n");
            sb.Append("</x:ExcelWorksheets>\n");
            sb.Append("<x:WindowHeight>12780</x:WindowHeight>\n");
            sb.Append("<x:WindowWidth>19035</x:WindowWidth>\n");
            sb.Append("<x:WindowTopX>0</x:WindowTopX>\n");
            sb.Append("<x:WindowTopY>15</x:WindowTopY>\n");
            sb.Append("<x:ProtectStructure>False</x:ProtectStructure>\n");
            sb.Append("<x:ProtectWindows>False</x:ProtectWindows>\n");
            sb.Append("</x:ExcelWorkbook>\n");
            sb.Append("</xml><![endif]-->\n");
            sb.Append("</head>\n");
            sb.Append("<body>\n");
            return sb.ToString();
        }




        protected void cmd_courts_selects_Click(object sender, EventArgs e)
        {
            String str_typeusers = Session["LOAITOA"].ToString();
            Get_Permission_Courts(str_typeusers);
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "window_Shows_courts()", true);
        }
        public void Get_Permission_Courts(String str_typeusers)
        {
            if (str_typeusers == "TOICAO")
            {
                Get_Courts_Options();

            }
            else if (str_typeusers == "CAPCAO")
            {
                Get_Courts_CC();
            }
            else if (str_typeusers == "CAPTINH")
            {
                Get_Courts_Tinh();
            }

        }
        public void Get_Courts_CC()
        {
            String str_donvi_id = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            QT_TUPHAP_BL qtBL = new QT_TUPHAP_BL();
            DataTable oDT = new DataTable();
            //oDT = qtBL.QT_Donvi_THADS_TINH(str_donvi_id);
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            oDT = oBL.GetDonVi_By_CapChaID_BCCC(Convert.ToDecimal(str_donvi_id));
            Getdata_Courts(oDT);
        }
        public void Get_Courts_Tinh()
        {
            String str_donvi_id = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            DataTable oDT = new DataTable();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            oDT = oBL.GET_Donvi_TA_TINH(str_donvi_id);
            Getdata_Courts(oDT);
        }
        public void Get_Object_Permission(String str_typeusers)
        {
            ListItem items = new ListItem();
            Drop_object.Items.Clear();
            if (str_typeusers == "CAPCAO")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp cao", "CAPCAO");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp tỉnh", "CAPTINH");
                Drop_object.Items.Add(items);
            }
            else if (str_typeusers == "CAPTINH")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp tỉnh", "CAPTINH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp huyện", "CAPHUYEN");
                Drop_object.Items.Add(items);
            }
            else if (str_typeusers == "TOICAO")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Tối cao", "TOICAO");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp cao", "CAPCAO");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp tỉnh", "CAPTINH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp huyện", "CAPHUYEN");
                Drop_object.Items.Add(items);
            }
        }
        public void Getdata_Courts(DataTable oDT)
        {
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            Hi_value_ID_Court.Value = String.Empty;
            hi_value_objects.Value = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            List<TreeviewNode_toaan> tvn = new List<TreeviewNode_toaan>();
            foreach (DataRow row in oDT.Rows)
            {
                TreeviewNode_toaan nodes = new TreeviewNode_toaan();
                nodes.ID = row["ID"].ToString();
                nodes.PARENT_ID = row["CAPCHAID"].ToString();
                nodes.TEXT = row["TEN"].ToString();
                tvn.Add(nodes);
            }
            Treeview_Load(TreeView_Courts, null, tvn);
            MP_Window_courts.Show();
        }
        protected void Drop_object_SelectedIndexChanged(object sender, EventArgs e)
        {
            reset_DropCourt();
        }

        #region Báo cáo
        private void LoadReport_baocao_Hinhthucxetxu_Tinhhuyen()
        {
            try
            {
                String v_court = "";
                v_court = Hi_value_ID_Court.Value;
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("vDonViID", CurrDonViID),
                        new OracleParameter("V_TUNGAY",txtThuly_Tu.Text.Trim()),
                        new OracleParameter("V_DENNGAY",txtThuly_Den.Text.Trim()),
                        new OracleParameter("v_TOAANID",v_court)
                        };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_HINHTHUCXETXU.BAOCAO_XETXUTRUCTUYEN_TINHHUYEN", parameters);

                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Tonghop_nhaplieu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_baocao_Hinhthucxetxu_Canbo()
        {
            try
            {
                String v_court = "";
                v_court = Hi_value_ID_Court.Value;
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("vDonViID", CurrDonViID),
                        new OracleParameter("V_TUNGAY",txtThuly_Tu.Text.Trim()),
                        new OracleParameter("V_DENNGAY",txtThuly_Den.Text.Trim()),
                        new OracleParameter("v_TOAANID",v_court)
                        };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_HINHTHUCXETXU.BAOCAO_XETXUTRUCTUYEN_CANBO", parameters);

                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Tonghop_nhaplieu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }

        //private void LoadReport_bcpt_1()
        //{
        //    try
        //    {
        //        String v_court = "";
        //        v_court = Hi_value_ID_Court.Value;
        //        CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

        //        STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
        //        DataTable tbl = oBL.Tong_hop_so_lieu_nhaplieu(CurrDonViID, DropTINHTRANG_THULY.SelectedValue,
        //                      DropTINHTRANG_GIAIQUYET.SelectedValue, txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), v_court);
        //        Literal Table_Str_Totals = new Literal();
        //        DataRow row = tbl.NewRow();
        //        //-----
        //        if (tbl != null && tbl.Rows.Count > 0)
        //        {
        //            row = tbl.Rows[0];
        //            Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
        //        }
        //        //-------------------Export---------------------------
        //        Response.Clear();
        //        Response.AddHeader("content-disposition", "attachment;filename=Tonghop_nhaplieu.xls");
        //        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        //        Response.ContentType = "application/vnd.xls";
        //        System.IO.StringWriter stringWrite = new System.IO.StringWriter();
        //        System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
        //        htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
        //        Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
        //        Table_Str_Totals.RenderControl(htmlWrite);
        //        Response.Write(stringWrite.ToString());
        //        Response.Write("</body>");
        //        Response.Write("</html>");   // add the style props to get the page orientation
        //        Response.End();
        //    }
        //    catch (Exception ex)
        //    {
        //        lblmsg.Text = ex.Message;
        //    }
        //}
        #endregion

        #region Báo cáo 
        protected void ddlLoaiBaocao_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiBaocao.SelectedValue == "1")
            {
                lblThuly_Tungay.Text = "Thụ lý từ ngày";
                lblThuly_Denngay.Text = "Đến ngày";
            }
            else if (ddlLoaiBaocao.SelectedValue == "2")
            {
                lblThuly_Tungay.Text = "Từ ngày";
                lblThuly_Denngay.Text = "Đến ngày";
            }
            else if (ddlLoaiBaocao.SelectedValue == "3")
            {
                lblThuly_Tungay.Text = "Từ ngày";
                lblThuly_Denngay.Text = "Đến ngày";
            }
        }

        #endregion

        private void reset_DropCourt()
        {
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            Hi_value_ID_Court.Value = String.Empty;
            hi_text_courts.Value = String.Empty;
            //TreeView_Courts.UncheckAllNodes();
            //TreeView_Courts -> uncheck client
            Treeview_UncheckNode(TreeView_Courts);
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), Guid.NewGuid().ToString(), "treeview_Unchecked('" + TreeView_Courts.ClientID + "')", true);
        }




        #region "TREEVIEW (HOLD OFF)"
        private void Treeview_Load(TreeView tv, TreeNode rootNode, List<TreeviewNode_toaan> listNodes)
        {
            tv.Nodes.Clear();
            TreeNode oRoot;
            if (rootNode == null)
            {
                List<TreeviewNode_toaan> rootNodes = listNodes.FindAll(x => x.ID == Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                if (rootNodes.Count > 0)
                {
                    foreach (TreeviewNode_toaan r in rootNodes)
                    {
                        oRoot = new TreeNode(r.TEXT, r.ID);
                        tv.Nodes.Add(oRoot);
                        Treeview_LoadChild(oRoot, "", oRoot, listNodes);
                        tv.Nodes[0].Expand();
                    }
                }
                else
                {
                    oRoot = new TreeNode("Danh sách", "0");
                    tv.Nodes.Add(oRoot);
                    Treeview_LoadChild(oRoot, "", oRoot, listNodes);
                    tv.Nodes[0].Expand();
                }
            }
            else
            {
                oRoot = rootNode;
                tv.Nodes.Add(oRoot);
                Treeview_LoadChild(oRoot, "", oRoot, listNodes);
                tv.Nodes[0].Expand();
            }
            //tv.Nodes[0].Expand();
            tv.ShowCheckBoxes = TreeNodeTypes.All;
            tv.ShowLines = true;
        }
        private void Treeview_LoadChild(TreeNode root, string dept, TreeNode currentNode, List<TreeviewNode_toaan> listNodes)
        {
            List<TreeviewNode_toaan> listchild = new List<TreeviewNode_toaan>();
            if (currentNode != null)
            {
                foreach (TreeviewNode_toaan n in listNodes)
                {
                    if (n.PARENT_ID == currentNode.Value)
                    {
                        listchild.Add(n);
                    }
                }
            }
            if (listchild.Count > 0)
            {
                foreach (TreeviewNode_toaan child in listchild)
                {
                    TreeNode nodechild;
                    nodechild = Treeview_CreateNode(child.ID, child.TEXT);
                    root.ChildNodes.Add(nodechild);
                    Treeview_LoadChild(nodechild, ".." + dept, nodechild, listNodes);
                    root.CollapseAll();
                }
            }
        }
        private TreeNode Treeview_CreateNode(string sNodeId, string sNodeText)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;
            return objTreeNode;
        }
        private void Treeview_UncheckNode(TreeView _treeView)
        {
            TreeNodeCollection nodeCollection = _treeView.Nodes;
            foreach (TreeNode node in nodeCollection)
            {
                node.Checked = false;
            }
        }
        #endregion

    }
}