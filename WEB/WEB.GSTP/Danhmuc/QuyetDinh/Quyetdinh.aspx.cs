using BL.GSTP;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.QuyetDinh
{
    public partial class Quyetdinh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropLoaiQD();
                    if (Request["loaiqd"] != null)
                    {
                        DropLoaiQD.SelectedValue = Request["loaiqd"].ToString();
                    }
                    decimal LoaiQDID = Convert.ToDecimal(DropLoaiQD.SelectedValue);
                    LoadLoaiAnApDung(LoaiQDID);
                    FillThuTu(GetListQuyetDinhByLoaiQD(LoaiQDID));
                    if (Request["pg"] != null)
                    {
                        hddPageIndex.Value = Request["pg"].ToString();
                    }
                    else
                    { hddPageIndex.Value = "1"; }
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadDropLoaiQD()
        {
            DropLoaiQD.Items.Clear();
            List<DM_QD_LOAI> lst = dt.DM_QD_LOAI.OrderBy(x => x.THUTU).ToList();
            if (lst != null && lst.Count > 0)
            {
                DropLoaiQD.DataSource = lst;
                DropLoaiQD.DataTextField = "TEN";
                DropLoaiQD.DataValueField = "ID";
                DropLoaiQD.DataBind();
            }
            else
            {
                DropLoaiQD.Items.Add(new ListItem("Chọn", "0"));
            }

            if (lst != null && lst.Count > 0)
            {
                ddlLoaiQD.DataSource = lst;
                ddlLoaiQD.DataTextField = "TEN";
                ddlLoaiQD.DataValueField = "ID";
                ddlLoaiQD.DataBind();
            }
            ddlLoaiQD.Items.Add(new ListItem("Chọn", "0"));
        }
        private void LoadData()
        {
            lbthongbao.Text = "";
            string TextKey = txtTimKiem.Text.Trim();
            decimal LoaiQdID = Convert.ToDecimal(DropLoaiQD.SelectedValue);
            int pageIndex = Convert.ToInt32(hddPageIndex.Value), pageSize = Convert.ToInt32(hddPageSize.Value);

            dgList.DataSource = null;
            dgList.DataBind();

            DM_QD_QUYETDINH_BL oBL = new DM_QD_QUYETDINH_BL();
            DataTable lst = oBL.DM_QD_QUYETDINH_SEARCH(LoaiQdID, TextKey, pageIndex, pageSize);

            if (lst != null && lst.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(lst.Rows[0]["Total"]);
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                pnlDataTable.Visible = cmdThutu.Visible = true;
                dgList.DataSource = lst;
                dgList.DataBind();
            }
            else
            {
                pnlDataTable.Visible = cmdThutu.Visible = false;
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "LyDo":
                        Response.Redirect("LyDo.aspx?loaiqd=" + DropLoaiQD.SelectedValue + "&qd=" + curr_id + "&pg=" + hddPageIndex.Value);
                        break;
                    case "Sua":
                        LoadEdit(curr_id);
                        hddQdID.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        Xoa(curr_id);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    DropDownList dropThuTuChildren = (DropDownList)e.Item.FindControl("DropThuTuChildren");
                    decimal LoaiQD = Convert.ToDecimal(rv["LOAIID"].ToString()), countItem = 0, ThuTu = 0;
                    decimal maxThutu = 0;

                    List<DM_QD_QUYETDINH> lst = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == LoaiQD).ToList();
                    if (lst != null && lst.Count > 0)
                    {
                        for (int i = 0; i <= lst.Count - 1; i++)
                        {
                            if (lst[i].THUTU != null)
                                if (lst[i].THUTU > maxThutu)
                                {
                                    maxThutu = Convert.ToDecimal(lst[i].THUTU);
                                }
                        }
                    }
                    for (int i = 1; i <= maxThutu; i++)
                    {
                        dropThuTuChildren.Items.Add(new ListItem(i.ToString(), i.ToString()));
                    }

                    ThuTu = Convert.ToDecimal(rv["THUTU"].ToString());
                    if (maxThutu <= ThuTu)
                    {
                        dropThuTuChildren.SelectedValue = maxThutu.ToString();
                    }
                    else
                    {
                        dropThuTuChildren.SelectedValue = ThuTu.ToString();
                    }

                    LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    lbtSua.Visible = oPer.CAPNHAT; lbtXoa.Visible = oPer.XOA;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadEdit(decimal id)
        {
            lbthongbao.Text = "";
            DM_QD_QUYETDINH qd = dt.DM_QD_QUYETDINH.Where(x => x.ID == id).FirstOrDefault<DM_QD_QUYETDINH>();
            if (qd != null)
            {
                ddlLoaiQD.SelectedValue = qd.LOAIID.ToString();
                txtMa.Text = qd.MA;
                txtTen.Text = qd.TEN;
                txtThoiHanThang.Text = string.IsNullOrEmpty(qd.THOIHAN_THANG + "") ? "" : qd.THOIHAN_THANG.ToString();
                txtThoiHanNgay.Text = string.IsNullOrEmpty(qd.THOIHAN_NGAY + "") ? "" : qd.THOIHAN_NGAY.ToString();

                chkHinhSu.Checked = string.IsNullOrEmpty(qd.ISHINHSU + "") ? false : Convert.ToBoolean(qd.ISHINHSU);
                chkDanSu.Checked = string.IsNullOrEmpty(qd.ISDANSU + "") ? false : Convert.ToBoolean(qd.ISDANSU);
                chkHonNhanGD.Checked = string.IsNullOrEmpty(qd.ISHNGD + "") ? false : Convert.ToBoolean(qd.ISHNGD);
                chkKDTM.Checked = string.IsNullOrEmpty(qd.ISKDTM + "") ? false : Convert.ToBoolean(qd.ISKDTM);
                chkLaoDong.Checked = string.IsNullOrEmpty(qd.ISLAODONG + "") ? false : Convert.ToBoolean(qd.ISLAODONG);
                chkHanhChinh.Checked = string.IsNullOrEmpty(qd.ISHANHCHINH + "") ? false : Convert.ToBoolean(qd.ISHANHCHINH);
                chkHieuluc.Checked = string.IsNullOrEmpty(qd.HIEULUC + "") ? false : Convert.ToBoolean(qd.HIEULUC);

                chkPhasan.Checked = string.IsNullOrEmpty(qd.ISPHASAN + "") ? false : Convert.ToBoolean(qd.ISPHASAN);
                chkXLHC.Checked = string.IsNullOrEmpty(qd.ISXLHC + "") ? false : Convert.ToBoolean(qd.ISXLHC);

                chkSoTham.Checked = string.IsNullOrEmpty(qd.ISSOTHAM + "") ? false : Convert.ToBoolean(qd.ISSOTHAM);
                chkPhuctham.Checked = string.IsNullOrEmpty(qd.ISPHUCTHAM + "") ? false : Convert.ToBoolean(qd.ISPHUCTHAM);
                chkGDTTT.Checked = string.IsNullOrEmpty(qd.ISGDTTT + "") ? false : Convert.ToBoolean(qd.ISGDTTT);
                chkISCONGBO.Checked = string.IsNullOrEmpty(qd.ISCONGBO + "") ? false : Convert.ToBoolean(qd.ISCONGBO);
                chkKetthuc.Checked = string.IsNullOrEmpty(qd.KET_THUC + "") ? false : Convert.ToBoolean(qd.KET_THUC);

                if (qd.THUTU != null && DropThuTu.Items.FindByValue(qd.THUTU.ToString()) != null)
                {
                    DropThuTu.SelectedValue = qd.THUTU.ToString();
                }
                txtThoiHanDuocCongBo.Text = qd.THOIHANDUOCCONGBO.ToString();
            }
        }
        private void Xoa(decimal id)
        {
            DM_QD_QUYETDINH qd = dt.DM_QD_QUYETDINH.Where(x => x.ID == id).FirstOrDefault<DM_QD_QUYETDINH>();
            if (qd != null)
            {
                dt.DM_QD_QUYETDINH.Remove(qd);
                dt.SaveChanges();
            }
            ResetControl();
            hddPageIndex.Value = "1";
            LoadData();
            lbthongbao.Text = "Xóa thành công!";
        }
        protected void DropLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ResetControl();
                decimal LoaiQDID = Convert.ToDecimal(DropLoaiQD.SelectedValue);
                ddlLoaiQD.SelectedValue = LoaiQDID.ToString();
                LoadLoaiAnApDung(LoaiQDID);

                FillThuTu(GetListQuyetDinhByLoaiQD(LoaiQDID));

                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                FillThuTu(GetListQuyetDinhByLoaiQD(Convert.ToDecimal(ddlLoaiQD.SelectedValue)));
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        
        private void LoadLoaiAnApDung(decimal LoaiQDID)
        {
            DM_QD_LOAI loaiQD = dt.DM_QD_LOAI.Where(x => x.ID == LoaiQDID).FirstOrDefault<DM_QD_LOAI>();
            if (loaiQD != null)
            {
                chkHinhSu.Checked = string.IsNullOrEmpty(loaiQD.ISHINHSU + "") ? false : Convert.ToBoolean(loaiQD.ISHINHSU);
                chkDanSu.Checked = string.IsNullOrEmpty(loaiQD.ISDANSU + "") ? false : Convert.ToBoolean(loaiQD.ISDANSU);
                chkHonNhanGD.Checked = string.IsNullOrEmpty(loaiQD.ISHNGD + "") ? false : Convert.ToBoolean(loaiQD.ISHNGD);
                chkKDTM.Checked = string.IsNullOrEmpty(loaiQD.ISKDTM + "") ? false : Convert.ToBoolean(loaiQD.ISKDTM);
                chkLaoDong.Checked = string.IsNullOrEmpty(loaiQD.ISLAODONG + "") ? false : Convert.ToBoolean(loaiQD.ISLAODONG);
                chkHanhChinh.Checked = string.IsNullOrEmpty(loaiQD.ISHANHCHINH + "") ? false : Convert.ToBoolean(loaiQD.ISHANHCHINH);

                chkPhasan.Checked = string.IsNullOrEmpty(loaiQD.ISPHASAN + "") ? false : Convert.ToBoolean(loaiQD.ISPHASAN);
                chkXLHC.Checked = string.IsNullOrEmpty(loaiQD.ISXLHC + "") ? false : Convert.ToBoolean(loaiQD.ISXLHC);
            }
        }
        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            decimal QdID = Convert.ToDecimal(hddQdID.Value);
            bool isNew = false;
            DM_QD_QUYETDINH qd = dt.DM_QD_QUYETDINH.Where(x => x.ID == QdID).FirstOrDefault<DM_QD_QUYETDINH>();
            if (qd == null)
            {
                if (!ValidateData())
                {
                    return;
                }
                isNew = true;
                qd = new DM_QD_QUYETDINH();
                qd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                qd.NGAYTAO = DateTime.Now;
            }
            else
            {
                if (qd.MA != txtMa.Text.Trim())
                {
                    string Ma = txtMa.Text.Trim();
                    int lengthMa = Ma.Length;
                    if (lengthMa == 0 || lengthMa > 20)
                    {
                        lbthongbao.Text = "Mã quyết định không được trống hoặc quá 20 ký tự. Hãy nhập lại!";
                        txtMa.Focus();
                        return ;
                    }
                    qd = dt.DM_QD_QUYETDINH.Where(x => x.MA.ToLower() == txtMa.Text.Trim().ToLower()).FirstOrDefault<DM_QD_QUYETDINH>();
                    if (qd != null)
                    {
                        lbthongbao.Text = "Mã quyết định này đã tồn tại. Hãy nhập lại!";
                        txtTen.Focus();
                        return;
                    }
                }
                if (qd.TEN != txtTen.Text.Trim())
                {
                    string Ten = txtTen.Text.Trim();
                    int lengthTen = Ten.Length;
                    if (lengthTen == 0 || lengthTen > 250)
                    {
                        lbthongbao.Text = "Tên quyết định không được trống hoặc quá 250 ký tự. Hãy nhập lại!";
                        txtTen.Focus();
                        return;
                    }
                    qd = dt.DM_QD_QUYETDINH.Where(x => x.TEN.ToLower() == Ten.ToLower()).FirstOrDefault<DM_QD_QUYETDINH>();
                    if (qd != null)
                    {
                        lbthongbao.Text = "Tên quyết định này đã tồn tại. Hãy nhập lại!";
                        txtTen.Focus();
                        return;
                    }
                }
                try
                {
                    if (!String.IsNullOrEmpty(txtThoiHanDuocCongBo.Text))
                    {
                        decimal? thoiHan = Convert.ToDecimal(txtThoiHanDuocCongBo.Text);
                        if (thoiHan != null && thoiHan < 0)
                        {
                            lbthongbao.Text = "Thời hạn được công bố không được nhỏ hơn không";
                            txtThoiHanDuocCongBo.Focus();
                            return;
                        }
                    }
                }
                catch
                {
                    lbthongbao.Text = "Thời hạn được công bố phải là số";
                    txtThoiHanDuocCongBo.Focus();
                    return;
                }
                qd.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                qd.NGAYSUA = DateTime.Now;
            }
            qd.LOAIID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            qd.MA = txtMa.Text.Trim();
            qd.TEN = txtTen.Text.Trim();
            qd.THOIHAN_THANG = string.IsNullOrEmpty(txtThoiHanThang.Text.Trim()) ? 0 : Convert.ToDecimal(txtThoiHanThang.Text);
            qd.THOIHAN_NGAY = string.IsNullOrEmpty(txtThoiHanNgay.Text.Trim()) ? 0 : Convert.ToDecimal(txtThoiHanNgay.Text);
            qd.THUTU = Convert.ToDecimal(DropThuTu.SelectedValue);
            qd.ISHINHSU = chkHinhSu.Checked ? 1 : 0;
            qd.ISDANSU = chkDanSu.Checked ? 1 : 0;
            qd.ISHNGD = chkHonNhanGD.Checked ? 1 : 0;
            qd.ISKDTM = chkKDTM.Checked ? 1 : 0;
            qd.ISLAODONG = chkLaoDong.Checked ? 1 : 0;
            qd.ISHANHCHINH = chkHanhChinh.Checked ? 1 : 0;

            qd.ISPHASAN = chkPhasan.Checked ? 1 : 0;
            qd.ISXLHC = chkXLHC.Checked ? 1 : 0;

            qd.ISSOTHAM = chkSoTham.Checked ? 1 : 0;
            qd.ISPHUCTHAM = chkPhuctham.Checked ? 1 : 0;
            qd.ISGDTTT = chkGDTTT.Checked ? 1 : 0;

            qd.HIEULUC = chkHieuluc.Checked ? 1 : 0;
            qd.ISCONGBO = chkISCONGBO.Checked ? 1 : 0;
            qd.KET_THUC = chkKetthuc.Checked ? 1 : 0;

            if (!String.IsNullOrEmpty(txtThoiHanDuocCongBo.Text))
            {
                qd.THOIHANDUOCCONGBO = Convert.ToDecimal(txtThoiHanDuocCongBo.Text);
            }
            else
            {
                qd.THOIHANDUOCCONGBO = null;
            }
            if (isNew)
            {
                dt.DM_QD_QUYETDINH.Add(qd);
            }
            dt.SaveChanges();
            ResetControl();
            hddPageIndex.Value = "1";
            LoadData();
            lbthongbao.Text = "Lưu thành công!";
        }
        protected void cmdXoa_Click(object sender, EventArgs e)
        {
            try
            {
                decimal QdID = Convert.ToDecimal(hddQdID.Value);
                Xoa(QdID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            try
            {
                ResetControl();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void ResetControl()
        {
            txtMa.Text = txtTen.Text = txtThoiHanThang.Text = txtThoiHanNgay.Text = lbthongbao.Text = "";
            DropThuTu.SelectedValue = "1";
            ddlLoaiQD.SelectedValue = "0";
            chkHinhSu.Checked = false;
            chkDanSu.Checked = false;
            chkHonNhanGD.Checked = false;
            chkKDTM.Checked = false;
            chkLaoDong.Checked = false;
            chkHanhChinh.Checked = false;
            chkPhasan.Checked = false;
            chkXLHC.Checked = false;
            chkSoTham.Checked = false;
            chkPhuctham.Checked = false;
            chkGDTTT.Checked = false;
            chkISCONGBO.Checked = false;
            txtThoiHanDuocCongBo.Text = "";
            chkKetthuc.Checked = false;
            chkHieuluc.Checked = false;

            decimal LoaiQD = Convert.ToDecimal(DropLoaiQD.SelectedValue);
            FillThuTu(GetListQuyetDinhByLoaiQD(LoaiQD));
            hddQdID.Value = "0";
        }
        private void FillThuTu(int Count)
        {
            DropThuTu.Items.Clear();
            if (Count > 0)
            {
                for (int i = 1; i <= Count; i++)
                {
                    DropThuTu.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
                DropThuTu.SelectedIndex = Count - 1;
            }
            else
            {
                DropThuTu.Items.Add(new ListItem("1", "1"));
            }
        }
        private int GetListQuyetDinhByLoaiQD(decimal LoaiQD)
        {
            int maxThutu = 0;
            List<DM_QD_QUYETDINH> lst = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == LoaiQD).ToList();
            if (lst != null && lst.Count > 0)
            {
                for (int i = 0; i <= lst.Count - 1; i++)
                {
                    if (lst[i].THUTU != null)
                        if (lst[i].THUTU > maxThutu)
                        {
                            maxThutu = (int)Convert.ToDecimal(lst[i].THUTU);
                        }
                }
            }

            return maxThutu + 1;
        }
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdThutu_Click(object sender, EventArgs e)
        {
            int ColIDIndex = 0;
            decimal qdID = 0;
            DM_QD_QUYETDINH qd = new DM_QD_QUYETDINH();
            foreach (DataGridItem oItem in dgList.Items)
            {
                qdID = Convert.ToDecimal(oItem.Cells[ColIDIndex].Text);
                qd = dt.DM_QD_QUYETDINH.Where(x => x.ID == qdID).FirstOrDefault<DM_QD_QUYETDINH>();
                DropDownList dropThuTu = (DropDownList)oItem.FindControl("DropThuTuChildren");
                qd.THUTU = Convert.ToInt32(dropThuTu.SelectedValue);
                qd.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                qd.NGAYSUA = DateTime.Now;
                dt.SaveChanges();
            }
            hddPageIndex.Value = "1";
            LoadData();
        }
        private bool ValidateData()
        {
            if(ddlLoaiQD.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn loại quyết định. Hãy chọn lại!";
                ddlLoaiQD.Focus();
                return false;
            }
            string Ma = txtMa.Text.Trim();
            int lengthMa = Ma.Length;
            if (lengthMa == 0 || lengthMa > 20)
            {
                lbthongbao.Text = "Mã quyết định không được trống hoặc quá 20 ký tự. Hãy nhập lại!";
                txtMa.Focus();
                return false;
            }
            string Ten = txtTen.Text.Trim();
            int lengthTen = Ten.Length;
            if (lengthTen == 0 || lengthTen > 250)
            {
                lbthongbao.Text = "Tên quyết định không được trống hoặc quá 250 ký tự. Hãy nhập lại!";
                txtTen.Focus();
                return false;
            }
            decimal qdID = Convert.ToDecimal(hddQdID.Value);
            DM_QD_QUYETDINH qd = dt.DM_QD_QUYETDINH.Where(x => x.MA.ToLower() == Ma.ToLower()).FirstOrDefault<DM_QD_QUYETDINH>();
            if (qd != null)
            {
                if (qd.ID != qdID)
                {
                    lbthongbao.Text = "Mã quyết định này đã tồn tại. Hãy nhập lại!";
                    txtTen.Focus();
                    return false;
                }
            }
            qd = dt.DM_QD_QUYETDINH.Where(x => x.TEN.ToLower() == Ten.ToLower()).FirstOrDefault<DM_QD_QUYETDINH>();
            if (qd != null)
            {
                if (qd.ID != qdID)
                {
                    lbthongbao.Text = "Tên quyết định này đã tồn tại. Hãy nhập lại!";
                    txtTen.Focus();
                    return false;
                }
            }
            try
            {
                if (!String.IsNullOrEmpty(txtThoiHanDuocCongBo.Text))
                {
                    decimal? thoiHan = Convert.ToDecimal(txtThoiHanDuocCongBo.Text);
                    if (thoiHan != null && thoiHan < 0)
                    {
                        lbthongbao.Text = "Thời hạn được công bố không được nhỏ hơn không";
                        txtThoiHanDuocCongBo.Focus();
                        return false;
                    }
                }
            }
            catch
            {
                lbthongbao.Text = "Thời hạn được công bố phải là số";
                txtThoiHanDuocCongBo.Focus();
                return false;
            }
            return true;
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
    }
}