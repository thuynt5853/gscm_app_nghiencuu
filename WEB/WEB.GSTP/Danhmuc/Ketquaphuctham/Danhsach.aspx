<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Danhmuc.Ketquaphuctham.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" runat="server" Value="20" />
    <asp:HiddenField ID="hddKqID" runat="server" Value="0" />
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
            padding-top: 10px;
        }

        .inputSearch {
            padding-left: 5px;
            padding-right: 5px;
            float: left;
            margin-right: 5px;
        }

        .head_panelDaCap {
            float: left;
            width: 100%;
            margin-top: 10px;
            border-top: 1px solid #ccc;
            padding-top: 10px;
        }
    </style>
    <div class="box" style="float: left; width: 99%;">
        <div class="box_nd" style="float: left; width: 99%;">
            <div class="truong" style="float: left; width: 99%;">

                <asp:Panel ID="pnlDonCap" runat="server">
                    <div class="DataInfo">
                        <div class="lbTitle_DonCap">Mã kết quả<span class="batbuoc">(*)</span></div>
                        <div class="inputData_DonCap">
                            <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="180px" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle_DonCap">Kết quả<span class="batbuoc">(*)</span></div>
                        <div class="inputData_DonCap">
                            <asp:TextBox ID="txtTen" CssClass="user" Width="99%" runat="server" MaxLength="250"></asp:TextBox>
                        </div>
                        <div class="clear"></div>
                        <div class="lbTitle_DonCap">Loại án áp dụng</div>
                        <div class="inputData_DonCap">
                              <asp:CheckBox ID="chkHinhSu" class="check" runat="server" Text="Hình sự" />
                            <asp:CheckBox ID="chkDanSu" class="check" runat="server" Text="Dân sự" />
                            <asp:CheckBox ID="chkHonNhanGD" class="check" runat="server" Text="Hôn nhân & Gia đình" />
                            <asp:CheckBox ID="chkKDTM" class="check" runat="server" Text="Kinh doanh thương mại" />
                            <br />
                            <asp:CheckBox ID="chkLaoDong" class="check" runat="server" Text="Lao động" />
                            <asp:CheckBox ID="chkHanhChinh" class="check" runat="server" Text="Hành chính" />
                              <asp:CheckBox ID="chkPhasan" class="check" runat="server"  Text="Phá sản" />
                              <asp:CheckBox ID="chkXLHC" class="check" runat="server"  Text="BP Xử lý hành chính" />
                        </div>
                        <div class="clear"></div>
                        <div class="lbTitle_DonCap">Ghi chú</div>
                        <div class="inputData_DonCap">
                            <asp:TextBox ID="txtGhiChu" runat="server" Width="99%" CssClass="user" MaxLength="250"></asp:TextBox>
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle_DonCap">Thứ tự</div>
                        <div class="inputData_DonCap">
                            <asp:DropDownList CssClass="user" ID="DropThuTu" runat="server" Width="70px"></asp:DropDownList>
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
                        <asp:TextBox runat="server" ID="txtTimKiem" Width="17%" CssClass="user inputSearch" placeholder="Mã kết quả, kết quả"></asp:TextBox>
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
                                    Mã kết quả
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("MA")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Kết quả
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TEN") %>
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
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa kết quả này? ');"></asp:LinkButton>
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
                alert('Bạn hãy nhập mã kết quả!');
                txtMa.focus();
                return false;
            } else {
                if (txtMa.value.lenght > 50) {
                    alert('Mã kết quả không quá 50 ký tự!');
                    txtMa.focus();
                    return false;
                }
            }
            var txtTen = document.getElementById('<%=txtTen.ClientID %>')
            if (txtTen.value.trim() == null || txtTen.value.trim() == "") {
                alert('Bạn hãy nhập kết quả!');
                txtTen.focus();
                return false;
            } else {
                if (txtTen.value.lenght > 250) {
                    alert('Kết quả không quá 250 ký tự!');
                    txtTen.focus();
                    return false;
                }
            }
            var txtGhiChu = document.getElementById('<%=txtGhiChu.ClientID %>')
            if (txtGhiChu.value.lenght > 250) {
                alert('Ghi chú không quá 250 ký tự!');
                txtGhiChu.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
