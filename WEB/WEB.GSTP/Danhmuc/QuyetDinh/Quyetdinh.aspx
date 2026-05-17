<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Quyetdinh.aspx.cs" Inherits="WEB.GSTP.Danhmuc.QuyetDinh.Quyetdinh" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" runat="server" Value="20" />
    <asp:HiddenField ID="hddQdID" runat="server" Value="0" />
    <style type="text/css">
        .lbTitle_DonCap {
            float: left;
            width: 13%;
            margin-bottom: 3px;
            font-weight: bold;
            margin-top: 6px;
        }

        .inputData_DonCap {
            float: left;
            width: 87%;
            margin-bottom: 8px;
        }

        .clear {
            clear: both;
        }

        .DataInfo {
            margin-left: 5px;
            margin-top: 10px;
            width: 99%;
            float: left;
            border-top: 1px solid #ccc;
            padding-top: 10px;
        }

        .inputSearch {
            padding-left: 5px;
            padding-right: 5px;
            float: left;
            margin-right: 5px;
        }

        .inputNumber {
            text-align: right;
        }

        .head_panelDaCap {
            float: left;
            width: 100%;
            margin-top: 10px;
            border-top: 1px solid #ccc;
            padding-top: 10px;
        }

        .class_nhomDM {
            margin-left: 3px;
        }
    </style>
    <div class="box" style="float: left; width: 99%;">
        <div class="box_nd" style="float: left; width: 99%;">
            <div class="truong" style="float: left; width: 99%;">
                <div class="class_nhomDM">
                    <span class="lbTitle_DonCap"><b>Chọn loại quyết định</b></span>
                    <asp:DropDownList CssClass="chosen-select" ID="DropLoaiQD" runat="server" Width="650px" AutoPostBack="True" OnSelectedIndexChanged="DropLoaiQD_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
                <asp:Panel ID="pnlDonCap" runat="server">
                    <div class="DataInfo">
                        <div class="lbTitle_DonCap">Loại quyết định<asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label></div>
                        <div class="class_nhomDM" style="padding-bottom: 5px;">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlLoaiQD" runat="server" Width="180px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiQD_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <div class="clear"></div>
                        <div class="lbTitle_DonCap">Mã quyết định<asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label></div>
                        <div class="inputData_DonCap">
                            <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="180px" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle_DonCap">Tên quyết định<asp:Label runat="server" ID="Label3" Text="(*)" ForeColor="Red"></asp:Label></div>
                        <div class="inputData_DonCap">
                            <asp:TextBox ID="txtTen" CssClass="user" Width="99%" runat="server" MaxLength="250"></asp:TextBox>
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle_DonCap">Thời hạn giải quyết</div>
                        <div class="inputData_DonCap">
                            <asp:TextBox ID="txtThoiHanThang" CssClass="user inputNumber" onkeypress="return isNumber(event)" Width="62px" runat="server" MaxLength="20"></asp:TextBox>
                            (Tháng)
                            <asp:TextBox ID="txtThoiHanNgay" CssClass="user inputNumber" onkeypress="return isNumber(event)" Width="62px" runat="server" MaxLength="20"></asp:TextBox>
                            (Ngày)
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle_DonCap">Thứ tự</div>
                        <div class="inputData_DonCap">
                            <asp:DropDownList CssClass="user" ID="DropThuTu" runat="server" Width="70px"></asp:DropDownList>
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle_DonCap" style="margin-top: 0px;">Loại án áp dụng</div>
                        <div class="inputData_DonCap">
                            <asp:CheckBox ID="chkHinhSu" CssClass="check" runat="server" Text="Hình sự" />
                            &nbsp;<asp:CheckBox ID="chkDanSu" class="check " runat="server" Text="Dân sự" />
                            &nbsp;<asp:CheckBox ID="chkHonNhanGD" class="check" runat="server" Text="Hôn nhân & Gia đình" />
                            &nbsp;
                            <asp:CheckBox ID="chkKDTM" class="check" runat="server" Text="Kinh doanh thương mại" />
                            <br />
                            <asp:CheckBox ID="chkLaoDong" class="check" runat="server" Text="Lao động" />
                            &nbsp;
                            <asp:CheckBox ID="chkHanhChinh" class="check" runat="server" Text="Hành chính" />
                            &nbsp;
                            <asp:CheckBox ID="chkPhasan" class="check" runat="server" Text="Phá sản" />
                            <asp:CheckBox ID="chkXLHC" class="check" runat="server" Text="BP Xử lý hành chính" />
                        </div>
                        <div class="clear"></div>
                        <div class="lbTitle_DonCap" style="margin-top: 0px;">Giai đoạn áp dụng</div>
                        <div class="inputData_DonCap">
                            <asp:CheckBox ID="chkSoTham" CssClass="check" runat="server" Text="Sơ thẩm" />
                            &nbsp;<asp:CheckBox ID="chkPhuctham" class="check " runat="server" Text="Phúc thẩm" />
                            &nbsp;<asp:CheckBox ID="chkGDTTT" class="check" runat="server" Text="GĐT, TT" />
                        </div>
                        <div class="clear"></div>
                        <div class="lbTitle_DonCap">Có công bố?</div>
                        <div class="inputData_DonCap" style="width: 2%;">
                            <asp:CheckBox ID="chkISCONGBO" runat="server" />
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle_DonCap">Thời hạn được công bố?</div>
                        <div class="inputData_DonCap" style="width: 2%;">
                            <asp:TextBox ID="txtThoiHanDuocCongBo" CssClass="user inputNumber" onkeypress="return isNumber(event)" runat="server" Width="62px" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="clear"></div>
                        <div class="lbTitle_DonCap">Quyết định gây kết thúc</div>
                        <div class="inputData_DonCap" style="width: 2%;">
                            <asp:CheckBox ID="chkKetthuc" runat="server" />
                        </div>
                        <div class="clear"></div>
                        <div class="lbTitle_DonCap">Hiệu lực</div>
                        <div class="inputData_DonCap" style="width: 2%;">
                            <asp:CheckBox ID="chkHieuluc" runat="server" />
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle_DonCap"></div>
                        <div class="inputData_DonCap">
                            <div class="bt" style="float: left; margin-right: 10px;">
                                <asp:Button ID="cmdCapNhat" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return KtratenDV()" OnClick="cmdCapNhat_Click" />
                                <asp:Button ID="cmdXoa" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="cmdXoa_Click" />
                                <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                            </div>
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle_DonCap"></div>
                        <div class="inputData_DonCap">
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red" Text=""></asp:Label>
                        </div>
                        <div class="clear"></div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlDataTable" runat="server">
                    <div class="head_panelDaCap">
                        <asp:TextBox runat="server" ID="txtTimKiem" Width="17%" CssClass="user inputSearch" placeholder="Mã, tên quyết định"></asp:TextBox>
                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" CausesValidation="false" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                    </div>
                    <div class="phantrang" id="PhanTrang_T" runat="server" style="float: left; width: 100%;">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                        </div>
                    </div>
                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                        <Columns>
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-Width="7%" ItemStyle-Width="7%" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Thứ tự
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:DropDownList CssClass="user" ID="DropThuTuChildren" runat="server" Width="98%"></asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="10%" ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Mã quyết định
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("MA")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Tên quyết định
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TEN") %>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="15%" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Thời hạn giải quyết
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("ThoiHan") %>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="15%" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Công bố?
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("ISCONGBO") %>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="9%" HeaderStyle-Width="9%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Lý do
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtLyDo" runat="server" Text="Lý do" CausesValidation="false" CommandName="LyDo" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Thao tác
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                    &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa quyết định này? ');"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                    <div class="phantrang" id="PhanTrang_D" runat="server">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                        </div>
                    </div>
                </asp:Panel>
                <div style="float: left; margin-top: 6px;" runat="server" id="div_Order">
                    <asp:Button ID="cmdThutu" runat="server" CssClass="buttoninput" Text="Lưu thứ tự" OnClick="cmdThutu_Click" />
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function KtratenDV() {
            var txtMa = document.getElementById('<%=txtMa.ClientID %>')
            if (txtMa.value.trim() == null || txtMa.value.trim() == "") {
                alert('Bạn hãy nhập mã quyết định!');
                txtMa.focus();
                return false;
            } else {
                if (txtMa.value.lenght > 20) {
                    alert('Mã quyết định không quá 20 ký tự!');
                    txtMa.focus();
                    return false;
                }
            }
            var txtTen = document.getElementById('<%=txtTen.ClientID %>')
            if (txtTen.value.trim() == null || txtTen.value.trim() == "") {
                alert('Bạn hãy nhập tên quyết định!');
                txtTen.focus();
                return false;
            } else {
                if (txtTen.value.lenght > 250) {
                    alert('Tên quyết định không quá 250 ký tự!');
                    txtTen.focus();
                    return false;
                }
            }
            return true;
        }
    </script>
</asp:Content>
