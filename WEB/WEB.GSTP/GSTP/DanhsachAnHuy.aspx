<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DanhsachAnHuy.aspx.cs" Inherits="WEB.GSTP.GSTP.DanhsachAnHuy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .DGChitietCol1_Css {
            float: left;
            width: 10%;
            font-weight: bold;
        }

        .DGChitietCol2_Css {
            float: left;
            width: 88%;
            font-weight: bold;
        }

        .ClearBoth {
            clear: both;
            margin-bottom: 3px;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <div class="box" style="float: left; width: 99.5%;">
        <div class="box_nd" style="float: left; width: 99%;">
            <div class="truong" style="float: left; width: 99%;">
                <div style="margin-left: 10px;">
                    <span style="font-weight: bold; text-transform: uppercase;">Danh sách các vụ án hủy</span>
                    <div style="float: left; width: 100%; margin: 5px 0px">
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red" Text=""></asp:Label>
                    </div>
                    <div style="clear: both;"></div>
                    <asp:Panel runat="server" ID="pndata">
                        <div class="phantrang">
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
                            AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" OnItemCommand="dgList_ItemCommand"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%">
                            <Columns>
                                <asp:TemplateColumn HeaderStyle-Width="35px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>STT</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hddStt" runat="server" Value='<%#Eval("TT")%>' />
                                        <%#Eval("TT")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Tên vụ án
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("VuAnID")%>' />
                                        <%#Eval("TenVuAn") %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Tòa xử
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hddToaAnID" runat="server" Value='<%#Eval("ToaAnID")%>' />
                                        <%#Eval("TenToaAn") %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Thẩm phán
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("TenTP") %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="101px" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Vai trò
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("VaiTro") %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Thẩm phán tự đánh giá
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtTPDanhGia" runat="server" Text="Đánh giá" CausesValidation="false" CommandName="TPDanhGia" ForeColor="#0e7eee"
                                            CommandArgument='<%#Eval("VuAnID") +";#"+Eval("TPID")+";#"+Eval("LoaiAn")+";#"+Eval("ToaAnID")+";#"+Eval("MAVAITRO")%>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Ủy ban HĐXX đánh giá
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtHDDanhGia" runat="server" Text="Đánh giá" CausesValidation="false" CommandName="HDDanhGia" ForeColor="#0e7eee"
                                            CommandArgument='<%#Eval("VuAnID") +";#"+Eval("TPID")+";#"+Eval("LoaiAn")+";#"+Eval("ToaAnID")+";#"+Eval("MAVAITRO")%>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                            </Columns>
                            <HeaderStyle CssClass="header"></HeaderStyle>
                            <ItemStyle CssClass="chan"></ItemStyle>
                            <PagerStyle Visible="false"></PagerStyle>
                        </asp:DataGrid>
                        <div class="phantrang">
                            <div class="sobanghi">
                                <asp:HiddenField ID="hdicha" runat="server" />
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
                </div>
            </div>
        </div>
    </div>
</asp:Content>
