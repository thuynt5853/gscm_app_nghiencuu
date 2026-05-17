using BL.GSTP;
using BL.GSTP.UTTP;
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

namespace WEB.GSTP.QLAN
{
    public partial class UTTPDi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session[ENUM_SESSION.SESSION_DONVIID]==null)
                {
                    Response.Redirect("/Trangchu.aspx");
                    Response.End();
                }
                decimal donviId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                var donvi = dt.DM_TOAAN.FirstOrDefault(s => s.ID == donviId);
                if (donvi.LOAITOA=="CAPHUYEN")
                {
                    Response.Redirect("/Trangchu.aspx");
                    Response.End();
                }
                LoadDataThuKy();
                LoadDataThamPhan();
                LoadDataVanBanUT();
                LoadDataQuocGiaUT();
                LoadDataKetQuaUT();
                LoadTatCaLoaiAn();
                LoadDataCapXetXu();
                LoadDataDonVi();
                LoadGrid();
            }
        }
        private void LoadDataDonVi()
        {
            string strDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            if (strDonViID != "")
            {
                decimal DonViID = Convert.ToDecimal(strDonViID);
                DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                ddlDonViUT.DataSource = oBL.DM_TOAAN_GETBY(DonViID);
                ddlDonViUT.DataTextField = "arrTEN";
                ddlDonViUT.DataValueField = "ID";
                ddlDonViUT.DataBind();
                ddlDonViUT.Items.Insert(0, new ListItem("---Tất cả---", "0"));

            }


        }
        void LoadDataCapXetXu()
        {
            ddlCapXetXu.Items.Clear();

            ddlCapXetXu.Items.Add(new ListItem("---Tất cả---", "0"));
            ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            ddlCapXetXu.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));

        }
        void LoadTatCaLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("---Tất cả---", "0"));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            ddlLoaiAn.Items.Add(new ListItem("BP XLHC", ENUM_LOAIVUVIEC.BPXLHC));

        }
        private void LoadDataKetQuaUT()
        {
            var dataketquauttp = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME("KETQUAUT");
            ddlKetQuaUT.DataSource = dataketquauttp;
            ddlKetQuaUT.DataTextField = "TEN";
            ddlKetQuaUT.DataValueField = "ID";
            ddlKetQuaUT.DataBind();
            ddlKetQuaUT.Items.Insert(0, new ListItem("--Tất cả--", "0"));

            //ddllKetQuaUT.DataSource = dataketquauttp;
            //ddllKetQuaUT.DataTextField = "TEN";
            //ddllKetQuaUT.DataValueField = "ID";
            //ddllKetQuaUT.DataBind();
            //ddllKetQuaUT.Items.Insert(0, new ListItem("--Tất cả--", "0"));
        }
        private void LoadDataQuocGiaUT()
        {
            var dataQuocGiaUT = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            ddlQuocGiaUT.DataSource = dataQuocGiaUT;
            ddlQuocGiaUT.DataTextField = "TEN";
            ddlQuocGiaUT.DataValueField = "ID";
            ddlQuocGiaUT.DataBind();
            ddlQuocGiaUT.Items.Insert(0, new ListItem("--Danh mục--", "0"));
        }
        private void LoadDataVanBanUT()
        {
            List<DM_BIEUMAU> data = dt.DM_BIEUMAU.ToList();
            DataTable table = new DataTable();
            table.Columns.Add("ID");
            table.Columns.Add("TEN");
            foreach (var item in data)
            {
                DataRow row = table.NewRow();
                row["ID"] = item.ID.ToString();
                row["TEN"] = item.MABM + "-" + item.TENBM;
                table.Rows.Add(row);
            }
            ddlVanBanUT.DataSource = table;
            ddlVanBanUT.DataTextField = "TEN";
            ddlVanBanUT.DataValueField = "ID";
            ddlVanBanUT.DataBind();
            ddlVanBanUT.Items.Insert(0, new ListItem("--Chọn văn bản--", "0"));
        }
        private void LoadDataThamPhan()
        {
            UYTHACTUPHAP_BL obl = new UYTHACTUPHAP_BL();
            DataTable oCBDT = obl.GETTHAMPHANTONGDAT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlThamPhan.DataSource = oCBDT;
            ddlThamPhan.DataTextField = "HOTEN";
            ddlThamPhan.DataValueField = "ID";
            ddlThamPhan.DataBind();
            ddlThamPhan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

        }
        private void LoadDataThuKy()
        {
            UYTHACTUPHAP_BL obl = new UYTHACTUPHAP_BL();
            DataTable oCBDT = obl.GETTHUKYTONGDAT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlThuKy.DataSource = oCBDT;
            ddlThuKy.DataTextField = "HOTEN";
            ddlThuKy.DataValueField = "ID";
            ddlThuKy.DataBind();
            ddlThuKy.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));

        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        private void LoadGrid()
        {
            //lấy dữ liệu án dân sự
            UYTHACTUPHAP_BL obl = new UYTHACTUPHAP_BL();
            int page_size = int.Parse(dropPageSize2.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            DataTable oDT = obl.GETUTTP_DI(txtDuongXu.Text, txtSoThuLy.Text, txtNgayThuLy.Text, ddlCapXetXu.SelectedValue, ddlLoaiAn.SelectedValue, ddlThuKy.SelectedValue, ddlThamPhan.SelectedValue, ddlVanBanUT.SelectedValue, ddlDonViUT.SelectedValue, ddlQuocGiaUT.SelectedValue, ddlLoaiTimKiem.SelectedValue, txtTuNgay.Text, txtDenNgay.Text, ddlKetQuaUT.SelectedValue,Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (oDT != null && oDT.Rows.Count > 0)
            {
                count_all = oDT.Rows.Count;
                #region "Xác định số lượng trang"
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
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string DataCommand = e.CommandArgument.ToString();
            string[] arrayData = DataCommand.Split(new char[] { '_' }, StringSplitOptions.RemoveEmptyEntries);
            decimal idDoiTuong = Convert.ToDecimal(arrayData[0]);
            string loaiAn = arrayData[1];
            var data = dt.UYTHACTUPHAPDIs.FirstOrDefault(s => s.IDDOITUONGTONGDAT == idDoiTuong && s.LOAIVUAN==loaiAn);
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            //lbthongBaoUpdate.Text = "";
            lblthongbao.Text = "";
            
            switch (e.CommandName)
            {
                case "CapNhat":
                    //thêm mới
                    

                    //upload biểu mẫu,đơn vị, cơ quan, quốc gia

                    if (data != null)
                    {
                        if (!CheckXoaSua(data.ID))
                        {
                            Cls_Comon.CallFunctionJS(this, this.GetType(), "scrollTop()");
                            break;
                        }
                        //hddid.Value = data.ID.ToString();
                        //LoadEdit(data.ID);
                        //sửa 
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_UTTPDi(1," + data.ID + ")");
                    }
                    else
                    {

                        //cập nhật
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_UTTPDi(0," + DataCommand + ")");
                    }

                    break;
                case "Sua":
                    if (!CheckXoaSua(data.ID))
                    {
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "scrollTop()");
                        break;
                    }

                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_UTTPDi(1," + data.ID + ")");
                    break;
                case "Xoa":
                    if (data == null)
                    {
                        lblthongbao.Text = "Bản ghi chưa được tống đạt";
                        return;
                    }
                    xoa(data.ID);
                    break;
            }
        }
  
        private bool CheckXoaSua(decimal id)
        {
            UYTHACTUPHAPDI oT = dt.UYTHACTUPHAPDIs.Where(x => x.ID == id).FirstOrDefault();
            //kiểm tra có thể xóa hay không
            if (oT.LOAIVUAN == ENUM_LOAIVUVIEC.AN_DANSU)
            {
                var tongDatDoiTuong = dt.ADS_TONGDAT_DOITUONG.FirstOrDefault(s => s.ID == oT.IDDOITUONGTONGDAT);
                if (tongDatDoiTuong.NGAYNHANTONGDAT.HasValue)
                {
                    lblthongbao.Text = "Không thể thực hiện thao tác do tòa cấp dưới đã nhận tống đạt!";
                    return false;
                }
            }
            else if (oT.LOAIVUAN == ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH)
            {
                var tongDatDoiTuong = dt.AHN_TONGDAT_DOITUONG.FirstOrDefault(s => s.ID == oT.IDDOITUONGTONGDAT);
                if (tongDatDoiTuong.NGAYNHANTONGDAT.HasValue)
                {
                    lblthongbao.Text = "Không thể thực hiện thao tác do tòa cấp dưới đã nhận tống đạt!";
                    return false;
                }
            }
            else if (oT.LOAIVUAN == ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI)
            {
                var tongDatDoiTuong = dt.AKT_TONGDAT_DOITUONG.FirstOrDefault(s => s.ID == oT.IDDOITUONGTONGDAT);
                if (tongDatDoiTuong.NGAYNHANTONGDAT.HasValue)
                {
                    lblthongbao.Text = "Không thể thực hiện thao tác do tòa cấp dưới đã nhận tống đạt!";
                    return false;
                }
            }
            else if (oT.LOAIVUAN == ENUM_LOAIVUVIEC.AN_LAODONG)
            {
                var tongDatDoiTuong = dt.ALD_TONGDAT_DOITUONG.FirstOrDefault(s => s.ID == oT.IDDOITUONGTONGDAT);
                if (tongDatDoiTuong.NGAYNHANTONGDAT.HasValue)
                {
                    lblthongbao.Text = "Không thể thực hiện thao tác do tòa cấp dưới đã nhận tống đạt!";
                    return false;
                }
            }
            else if (oT.LOAIVUAN == ENUM_LOAIVUVIEC.AN_HANHCHINH)
            {
                var tongDatDoiTuong = dt.AHC_TONGDAT_DOITUONG.FirstOrDefault(s => s.ID == oT.IDDOITUONGTONGDAT);
                if (tongDatDoiTuong.NGAYNHANTONGDAT.HasValue)
                {
                    lblthongbao.Text = "Không thể thực hiện thao tác do tòa cấp dưới đã nhận tống đạt!";
                    return false;
                }
            }
            else if (oT.LOAIVUAN == ENUM_LOAIVUVIEC.AN_PHASAN)
            {
                var tongDatDoiTuong = dt.APS_TONGDAT_DOITUONG.FirstOrDefault(s => s.ID == oT.IDDOITUONGTONGDAT);
                if (tongDatDoiTuong.NGAYNHANTONGDAT.HasValue)
                {
                    lblthongbao.Text = "Không thể thực hiện thao tác do tòa cấp dưới đã nhận tống đạt!";
                    return false;
                }
            }
            return true;
        }
        public void xoa(decimal id)
        {
            if (!CheckXoaSua(id))
            {
                return;
            }
            UYTHACTUPHAPDI oT = dt.UYTHACTUPHAPDIs.Where(x => x.ID == id).FirstOrDefault();
            dt.UYTHACTUPHAPDIs.Remove(oT);
            int count=dt.SaveChanges();
            
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            
            if (count>0)
            {
                lblthongbao.Text = "Xóa thành công!";
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
                LinkButton lbtCapNhat = (LinkButton)e.Item.FindControl("lblCapNhat");

                string DataCommand = lbtCapNhat.CommandArgument.ToString();
                string[] arrayData = DataCommand.Split(new char[] { '_' }, StringSplitOptions.RemoveEmptyEntries);
                decimal iDDoiTuong = Convert.ToDecimal(arrayData[0]);
                //kiểm tra nếu có dữ liệu trong bảng UYTHACTUPHAPDI
                var data = dt.UYTHACTUPHAPDIs.FirstOrDefault(s => s.IDDOITUONGTONGDAT == iDDoiTuong);
                if (data == null)
                {
                    //update

                    lbtCapNhat.Text = "Sửa";
                }
                else
                {
                    if (data.KETQUAUT.HasValue)
                    {
                        if (data.KETQUAUT.Value>0)
                        {
                            lbtCapNhat.Text = "Sửa";
                        }
                    }
                    
                    
                }
                decimal toaanid = Convert.ToDecimal(e.Item.Cells[1].Text);
                decimal toaanCurrent = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (toaanid== toaanCurrent)
                {
                    lblSua.Visible = false;
                    lbtCapNhat.Visible = false;
                    lbtXoa.Visible = false;

                }
                else
                {
                    lblSua.Visible = true;
                    lbtCapNhat.Visible = true;
                    lbtXoa.Visible = true;
                }
            }
        }


        //btnInDanhSach_Click
        protected void btnInDanhSach_Click(object sender, EventArgs e)
        {
            try
            {
                UYTHACTUPHAP_BL bl = new UYTHACTUPHAP_BL();
                DataTable tbl = bl.GETUTTP_DI_INDANHSACH(txtDuongXu.Text, txtSoThuLy.Text, txtNgayThuLy.Text, ddlCapXetXu.SelectedValue, ddlLoaiAn.SelectedValue, ddlThuKy.SelectedValue, ddlThamPhan.SelectedValue, ddlVanBanUT.SelectedValue, ddlDonViUT.SelectedValue, ddlQuocGiaUT.SelectedValue, ddlLoaiTimKiem.SelectedValue, txtTuNgay.Text, txtDenNgay.Text, ddlKetQuaUT.SelectedValue, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }

                string TenFile = "UyThacTuPhapDI";
                string KieuFile = ".xls";
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: Table_Str_Totals.Text, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadExcel.aspx?cacheKey=" + cacheKey + "&FileName=" + TenFile + "&Extension=" + KieuFile + "';", true);

            }
            catch (Exception ex)
            {
                lblthongbao.Text = ex.Message;
            }
        }

        protected void btnQuayLai_Click(object sender, EventArgs e)
        {
            
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            txtDuongXu.Text = "";
            
            txtSoThuLy.Text = "";
            txtNgayThuLy.Text = "";
            ddlCapXetXu.SelectedIndex = 0;
            ddlLoaiAn.SelectedIndex = 0;
            ddlThuKy.SelectedIndex = 0;
            ddlThamPhan.SelectedIndex = 0;
            ddlVanBanUT.SelectedIndex = 0;
            ddlDonViUT.SelectedIndex = 0;
            ddlQuocGiaUT.SelectedIndex = 0;
            ddlLoaiTimKiem.SelectedIndex = 0;
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
            ddlKetQuaUT.SelectedIndex = 0;

        }
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";

        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "scrollTop()");
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "scrollTop()");
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "scrollTop()");
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "scrollTop()");
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "scrollTop()");
        }
        #endregion
        //cmdLammoi_Click
        //btnThemmoi_Click
    }
}